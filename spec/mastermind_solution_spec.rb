require 'mastermind_solution'

describe MastermindSolution do

  context "test random samples for randomness" do
    # test the MastermindSolution initializer that it randomizes the input array relatively evenly
    # 1000x.MastermindSolution.new('RGBY') should output each first character approximately 25%
    # expect within 5% of 25% for the test of each R,G,B,Y

    before :all do
      @results = Hash.new(0) # defaults to zero
      1000.times do
        solution = MastermindSolution.new({:solution_choices => 'RGBO', :solution_length => 1}).to_s
        @results[solution] += 1
      end
      puts @results
    end

    it "creates the solution with the first character of 'R' approximately 25% of the time" do
      percentage = (@results['R'] / 1000.0) * 100
      expect(percentage).to be_within(2).of(25)
    end


  end

  context "generate solution based upon possibilities input" do
    it "creates and object with a solution of 'R' with the inputs 'R' and 1" do
      expect(MastermindSolution.new({:solution_choices => 'R', :solution_length => 1}).to_s).to eq('R')
    end

    it "creates and object with a solution of 'G' with the inputs 'G' and 1" do
      expect(MastermindSolution.new({:solution_choices => 'G', :solution_length => 1}).to_s).to eq('G')
    end

    it "creates and object with a solution of 'B' with the inputs 'B' and 1" do
      expect(MastermindSolution.new({:solution_choices => 'B', :solution_length => 1}).to_s).to eq('B')
    end

    it "creates and object with a solution of 'R' with the inputs 'RG' and 1" do
      allow_any_instance_of(Array).to receive(:shuffle) { ['R','G'] }
      expect(MastermindSolution.new({:solution_choices => 'RG', :solution_length => 1}).to_s).to eq('R')
    end

    it "creates and object with a solution of 'G' with the inputs 'RG' and 1" do
      allow_any_instance_of(Array).to receive(:shuffle) { ['G','R'] }
      expect(MastermindSolution.new({:solution_choices => 'RG', :solution_length => 1}).to_s).to eq('G')
    end

    it "creates and object with a solution of 'BG' with the inputs 'RGB' and 2" do
      allow_any_instance_of(Array).to receive(:shuffle) { ['B','G', 'R'] }
      expect(MastermindSolution.new({:solution_choices => 'RGB', :solution_length => 2}).to_s).to eq('BG')
    end

    it "creates and object with a solution of 'GYOB' with the inputs 'GBYRPTO' and 4" do
      allow_any_instance_of(Array).to receive(:shuffle) { ['G','Y', 'O', 'B', 'P', 'T', 'R'] }
      expect(MastermindSolution.new({:solution_choices => 'GBYRPTO', :solution_length => 4}).to_s).to eq('GYOB')
    end
  end

end
