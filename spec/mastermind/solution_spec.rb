require 'mastermind/solution'

describe Mastermind::Solution do

  context "test random samples for randomness" do
    before :all do
      @results = Hash.new(0) # defaults to zero
      1000.times do
        solution = Mastermind::Solution.new({:choices => 'RGBO', :length => 1}).to_s
        @results[solution] += 1
      end
    end

    it "creates the solution with the first character of 'R' approximately 25% of the time" do
      percentage = (@results['R'] / 1000.0) * 100
      expect(percentage).to be_within(4).of(25)
    end

    it "creates the solution with the first character of 'G' approximately 25% of the time" do
      percentage = (@results['G'] / 1000.0) * 100
      expect(percentage).to be_within(4).of(25)
    end

    it "creates the solution with the first character of 'B' approximately 25% of the time" do
      percentage = (@results['B'] / 1000.0) * 100
      expect(percentage).to be_within(4).of(25)
    end

    it "creates the solution with the first character of 'O' approximately 25% of the time" do
      percentage = (@results['O'] / 1000.0) * 100
      expect(percentage).to be_within(4).of(25)
    end
  end

  context "generate solution based upon possibilities input" do
    it "creates and object with a solution of 'R' with the inputs 'R' and 1" do
      expect(Mastermind::Solution.new({:choices => 'R', :length => 1}).to_s).to eq('R')
    end

    it "creates and object with a solution of 'G' with the inputs 'G' and 1" do
      expect(Mastermind::Solution.new({:choices => 'G', :length => 1}).to_s).to eq('G')
    end

    it "creates and object with a solution of 'B' with the inputs 'B' and 1" do
      expect(Mastermind::Solution.new({:choices => 'B', :length => 1}).to_s).to eq('B')
    end

    it "creates and object with a solution of 'R' with the inputs 'RG' and 1" do
      allow_any_instance_of(Array).to receive(:shuffle) { ['R','G'] }
      expect(Mastermind::Solution.new({:choices => 'RG', :length => 1}).to_s).to eq('R')
    end

    it "creates and object with a solution of 'G' with the inputs 'RG' and 1" do
      allow_any_instance_of(Array).to receive(:shuffle) { ['G','R'] }
      expect(Mastermind::Solution.new({:choices => 'RG', :length => 1}).to_s).to eq('G')
    end

    it "creates and object with a solution of 'BG' with the inputs 'RGB' and 2" do
      allow_any_instance_of(Array).to receive(:shuffle) { ['B','G', 'R'] }
      expect(Mastermind::Solution.new({:choices => 'RGB', :length => 2}).to_s).to eq('BG')
    end

    it "creates and object with a solution of 'GYOB' with the inputs 'GBYRPTO' and 4" do
      allow_any_instance_of(Array).to receive(:shuffle) { ['G','Y', 'O', 'B', 'P', 'T', 'R'] }
      expect(Mastermind::Solution.new({:choices => 'GBYRPTO', :length => 4}).to_s).to eq('GYOB')
    end
  end

end
