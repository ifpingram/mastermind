class MastermindSolution

  def initialize params

  end

  def to_s
    'R'
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
  end

end
