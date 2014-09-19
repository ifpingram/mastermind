class MastermindSolution

  attr_reader :solution

  def initialize params
    if params[:solution]
      @solution = String.new(params[:solution]).split(//)
    else
      randomized_array = params[:solution_choices].split(//).shuffle
      @solution = randomized_array.slice(0,params[:solution_length])
    end
  end

  def check_if_color_matches_position guess_char, guess_index
    @solution[guess_index] == guess_char
  end

  def check_if_color_exists guess_char
    @solution.include?(guess_char)
  end

  def mark_index_as_matched index_value
    @solution[index_value] = ' '
  end

  def mark_first_index_as_matched guess_char
    solution_index_to_remove = @solution.to_a.index(guess_char)
    @solution[solution_index_to_remove] = ' '
  end

  def to_a
    solution
  end

  def to_s
    solution.join.to_s
  end
end