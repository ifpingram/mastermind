class MastermindSolution

  attr_reader :choices, :guess_length, :solution

  def initialize params
    @choices = params[:choices]
    @guess_length = params[:guess_length]
    solution_array = choices.split(//)
    randomized_array = solution_array.shuffle
    output_array = []
    guess_length.times { output_array << randomized_array.shift }
    @solution = output_array.join
    # count = params[:guess_length]
    # solution_array = @solution.to_array.shuffle
    # count.times { solution_array.shift }
  end

  def to_s
    solution.to_s
  end

  # 'RGBY'
  # array = ['R,'G','B','Y']
  # array.shuffle => known stat
  # .randomize, array.pop => last element and removes it from the list

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

    it "creates and object with a solution of 'R' with the inputs 'RG' and 1" do
      allow_any_instance_of(Array).to receive(:shuffle) { ['R','G'] }
      expect(MastermindSolution.new({:choices => 'RG', :guess_length => 1}).to_s).to eq('R')
    end

    it "creates and object with a solution of 'G' with the inputs 'RG' and 1" do
      allow_any_instance_of(Array).to receive(:shuffle) { ['G','R'] }
      expect(MastermindSolution.new({:choices => 'RG', :guess_length => 1}).to_s).to eq('G')
    end

    it "creates and object with a solution of 'BG' with the inputs 'RGB' and 2" do
      allow_any_instance_of(Array).to receive(:shuffle) { ['B','G', 'R'] }
      expect(MastermindSolution.new({:choices => 'RGB', :guess_length => 2}).to_s).to eq('BG')
    end

    it "creates and object with a solution of 'GYOB' with the inputs 'GBYRPTO' and 4" do
      allow_any_instance_of(Array).to receive(:shuffle) { ['G','Y', 'O', 'B', 'P', 'T', 'R'] }
      expect(MastermindSolution.new({:choices => 'GBYRPTO', :guess_length => 4}).to_s).to eq('GYOB')
    end
  end

end
