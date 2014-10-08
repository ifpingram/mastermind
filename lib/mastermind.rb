require 'mastermind_solution'

class Mastermind
  class DuplicateNotAllowedException < StandardError; end
  class InvalidInputException < StandardError; end
  class InvalidInputTypeException < StandardError; end

  def initialize solution=MastermindSolution.new({:solution_choices => 'R', :solution_length => 1})
    @solution = solution
  end

  def is_guess_correct? guess
    @latest_guess = format_counted_matches(count_matches(check(guess)))
    return @latest_guess == '@@@@'
  end

  def show_guess_result
    @latest_guess
  end

  # private

  def check guess
    # if not string then exception
    raise Mastermind::InvalidInputTypeException unless guess.is_a? String
    guess_array = guess.to_s.split(//)

    result_array = initialize_array_of_no_matches(guess_array.length)

    guess_array.each_with_index do |guess_char,guess_index|

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
    raise Mastermind::InvalidInputException if matches.empty?
    raise Mastermind::InvalidInputTypeException unless matches.is_a?(Array)

    count_of_matches = {:match_color_and_position => 0, :match_color_not_position => 0, :no_match => 0}

    matches.each do |match_type|
      count_of_matches[match_type] += 1 rescue raise Mastermind::InvalidInputException
    end

    count_of_matches
  end

  FORMAT_TEMPLATE = {:match_color_and_position => '@', :match_color_not_position => '+', :no_match => '.'}

  def format_counted_matches counted_matches
    counted_matches.map { |key,value| FORMAT_TEMPLATE[key]*value }.join
  end
end