class MastermindSolution

  attr_reader :solution

  def initialize params
    randomized_array = params[:solution_choices].split(//).shuffle
    @solution = randomized_array.slice(0,params[:solution_length])
  end

  def to_a
    solution
  end

  def to_s
    solution.join.to_s
  end
end