class MastermindSolution

  attr_reader :solution

  def initialize params
    @solution = params[:choices]
  end

  def to_s
    solution.to_s
  end

end

# class MastermindGuess
#
# end

# guess_value = gets "enter your guess:"
# guess = MastermnindGuess.new(guess_value)
# guess.is_valid?

# Mastermind.new(MastermindSolution.new("RGBYO", ))

describe MastermindSolution do

  context "generate solution based upon possibilities input" do
    it "creates and object with a solution of 'R' with the inputs 'R' and 1" do
      expect(MastermindSolution.new({:choices => 'R', :guess_length => 1}).to_s).to eq('R')
    end

    it "creates and object with a solution of 'G' with the inputs 'G' and 1" do
      expect(MastermindSolution.new({:choices => 'G', :guess_length => 1}).to_s).to eq('G')
    end

    it "creates and object with a solution of 'B' with the inputs 'B' and 1" do
      expect(MastermindSolution.new({:choices => 'B', :guess_length => 1}).to_s).to eq('B')
    end
  end

end
