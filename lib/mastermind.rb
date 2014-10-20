require 'mastermind/solution'
require 'mastermind/reader'
require 'mastermind/writer'

class Mastermind
  class InvalidInputTypeException < StandardError; end
  class InvalidInputLengthException < StandardError; end
  class InvalidInputCharacterException < StandardError; end

  attr_accessor :solution, :writer, :reader

  def initialize(writer = Mastermind::Writer.new, reader = Mastermind::Reader.new, solution=Mastermind::Solution.new({:choices => 'RBGYO', :length => 4}))
    @solution = solution
    @writer = writer
    @reader = reader
  end

  def play
    writer.welcome

    guess_result = false

    until guess_result
      guess_result = make_guess
    end

    writer.goodbye
  end

  #private

  def make_guess
    writer.prompt_for_guess
    guess = reader.receive_guess
    # verify input and output error message if there was an error/exception
    begin
      if is_guess_correct?(guess)
        writer.guess_was_correct
        return true
      else
        writer.guess_was_incorrect(show_guess_result) # show_guess_result => '....', '+@.+'
        return false
      end
    rescue Mastermind::InvalidInputLengthException
      writer.input_length_error
    rescue Mastermind::InvalidInputCharacterException
      writer.input_character_error
    end
  end

  def is_guess_correct? guess
    verify_input(guess)
    @latest_guess = format_counted_matches(count_matches(check(guess)))
    return @latest_guess == '@@@@'
  end

  def show_guess_result
    @latest_guess
  end

  # private
  def verify_input guess
    raise Mastermind::InvalidInputTypeException unless guess.is_a? String
    raise Mastermind::InvalidInputLengthException unless guess.length == @solution.original.length
  end

  def check guess
    @solution.modifiable = @solution.original.clone
    guess_array = guess.to_s.split(//)

    result_array = initialize_array_of_no_matches(guess_array.length)

    guess_array.each_with_index do |guess_char,guess_index|
      raise Mastermind::InvalidInputCharacterException unless @solution.choices.include? guess_char

      if @solution.check_if_color_matches_position(guess_char,guess_index)
        result_array[guess_index] = :match_color_and_position
        @solution.mark_index_as_matched(guess_index)

      elsif @solution.check_if_color_exists(guess_char)
        result_array[guess_index] = :match_color_not_position
        @solution.mark_first_index_as_matched(guess_char)

      end
    end

    result_array
  end

  # private
  def initialize_array_of_no_matches guess_length
    Array.new(guess_length, :no_match)
  end

  def count_matches matches
    count_of_matches = {:match_color_and_position => 0, :match_color_not_position => 0, :no_match => 0}

    matches.each do |match_type|
      count_of_matches[match_type] += 1
    end

    count_of_matches
  end

  FORMAT_TEMPLATE = {:match_color_and_position => '@', :match_color_not_position => '+', :no_match => '.'}

  def format_counted_matches counted_matches
    counted_matches.map { |key,value| FORMAT_TEMPLATE[key]*value }.join
  end
end

if __FILE__==$0
  Mastermind.new.play # this will only run if the script was the main, not load'd or require'd
end
