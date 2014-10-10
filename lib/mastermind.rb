require 'mastermind_solution'

class Mastermind
  class InvalidInputTypeException < StandardError; end
  class InvalidInputLengthException < StandardError; end
  class InvalidInputCharacterException < StandardError; end

  def initialize mastermind_solution=MastermindSolution.new({:solution_choices => 'RBGY', :solution_length => 4})
    @mastermind_solution = mastermind_solution
  end

  def is_guess_correct? guess
    verify_input(guess)
    @latest_guess = format_counted_matches(count_matches(check(guess)))
    puts "Latest guess = #{@latest_guess}"
    return @latest_guess == '@@@@'
  end

  def show_guess_result
    @latest_guess
  end

  # private
  def verify_input guess
    raise Mastermind::InvalidInputTypeException unless guess.is_a? String
    raise Mastermind::InvalidInputLengthException unless guess.length == @mastermind_solution.solution.length
  end

  def check guess
    @mastermind_solution.solution = @mastermind_solution.master_solution.clone
    guess_array = guess.to_s.split(//)

    result_array = initialize_array_of_no_matches(guess_array.length)

    guess_array.each_with_index do |guess_char,guess_index|
      raise Mastermind::InvalidInputCharacterException unless @mastermind_solution.solution_choices.include? guess_char

      if @mastermind_solution.check_if_color_matches_position(guess_char,guess_index)
        result_array[guess_index] = :match_color_and_position
        @mastermind_solution.mark_index_as_matched(guess_index)

      elsif @mastermind_solution.check_if_color_exists(guess_char)
        result_array[guess_index] = :match_color_not_position
        @mastermind_solution.mark_first_index_as_matched(guess_char)

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