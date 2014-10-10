require 'mastermind_solution'

describe MastermindSolution do

  context "test random samples for randomness" do
    before :all do
      @results = Hash.new(0) # defaults to zero
      1000.times do
        solution = MastermindSolution.new({:choices => 'RGBO', :solution_length => 1}).to_s
        @results[solution] += 1
      end
    end

    it "creates the solution with the first character of 'R' approximately 25% of the time" do
      percentage = (@results['R'] / 1000.0) * 100
      expect(percentage).to be_within(2).of(25)
    end

    it "creates the solution with the first character of 'G' approximately 25% of the time" do
      percentage = (@results['G'] / 1000.0) * 100
      expect(percentage).to be_within(2).of(25)
    end

    it "creates the solution with the first character of 'B' approximately 25% of the time" do
      percentage = (@results['B'] / 1000.0) * 100
      expect(percentage).to be_within(2).of(25)
    end

    it "creates the solution with the first character of 'O' approximately 25% of the time" do
      percentage = (@results['O'] / 1000.0) * 100
      expect(percentage).to be_within(2).of(25)
    end
  end

  context "generate solution based upon possibilities input" do
    it "creates and object with a solution of 'R' with the inputs 'R' and 1" do
      expect(MastermindSolution.new({:choices => 'R', :solution_length => 1}).to_s).to eq('R')
    end

    it "creates and object with a solution of 'G' with the inputs 'G' and 1" do
      expect(MastermindSolution.new({:choices => 'G', :solution_length => 1}).to_s).to eq('G')
    end

    it "creates and object with a solution of 'B' with the inputs 'B' and 1" do
      expect(MastermindSolution.new({:choices => 'B', :solution_length => 1}).to_s).to eq('B')
    end

    it "creates and object with a solution of 'R' with the inputs 'RG' and 1" do
      allow_any_instance_of(Array).to receive(:shuffle) { ['R','G'] }
      expect(MastermindSolution.new({:choices => 'RG', :solution_length => 1}).to_s).to eq('R')
    end

    it "creates and object with a solution of 'G' with the inputs 'RG' and 1" do
      allow_any_instance_of(Array).to receive(:shuffle) { ['G','R'] }
      expect(MastermindSolution.new({:choices => 'RG', :solution_length => 1}).to_s).to eq('G')
    end

    it "creates and object with a solution of 'BG' with the inputs 'RGB' and 2" do
      allow_any_instance_of(Array).to receive(:shuffle) { ['B','G', 'R'] }
      expect(MastermindSolution.new({:choices => 'RGB', :solution_length => 2}).to_s).to eq('BG')
    end

    it "creates and object with a solution of 'GYOB' with the inputs 'GBYRPTO' and 4" do
      allow_any_instance_of(Array).to receive(:shuffle) { ['G','Y', 'O', 'B', 'P', 'T', 'R'] }
      expect(MastermindSolution.new({:choices => 'GBYRPTO', :solution_length => 4}).to_s).to eq('GYOB')
    end
  end

end
