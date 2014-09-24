require 'mastermind'

describe Mastermind do

  context "allow duplicates in the solution" do
    [
     ['RRRR','RRRR','@@@@'],
     ['RRRB','RRRY','@@@.'],
     ['BRRR','YRRR','@@@.'],
     ['BRYR','YRYR','@@+.'],
     ['RGRY','RGBB','@@..'],
     ['RGRY','RBBB','@...'],
     ['RRBO','RRYB','@@+.'],
     ['RGBY','RBYO','@++.'],
     ['RGBY','YRGB','++++'],
     ['RGBY','YRGO','+++.'],
     ['RGBY','GROA','++..'],
     ['RGBY','ACDE','....'],
    ].each do |solution_attempt_output|
      it "outputs '#{solution_attempt_output[2]}' when the solution is '#{solution_attempt_output[0]}' and the guess is '#{solution_attempt_output[1]}'" do
        expect(Mastermind.new(MastermindSolution.new({:solution => solution_attempt_output[0]})).attempt(solution_attempt_output[1])).to eq(solution_attempt_output[2])
      end
    end
  end


  context "verifying input with formatted output" do
    {'RGBO'=>['WXYZ','....'],
     'RGBY'=>['RGBY','@@@@'],
     'RGBY'=>['RGYO','@@+.'],
     'RGBYOZ'=>['RGYBIJ','@@++..'],
     'R'=>['R','@'],
    }.each do |solution,attempt|
      it "outputs '#{attempt[1]}' when the solution is '#{solution}' and the guess is '#{attempt[0]}'" do
        allow_any_instance_of(Array).to receive(:shuffle) { solution.split(//) }
        expect(Mastermind.new(MastermindSolution.new({:solution_choices => solution, :solution_length => 4})).attempt(attempt[0])).to eq(attempt[1])
      end
    end
  end

  context "outputting formatted counted matches" do
    it "outputs '.' when the input is {:no_match => 1}" do
      expect(Mastermind.new.format_counted_matches({:no_match=>1})).to eq('.')
    end

    it "outputs '+' when the input is {:match_color_not_position => 1}" do
      expect(Mastermind.new.format_counted_matches({:match_color_not_position=>1})).to eq('+')
    end

    it "outputs '@' when the input is {:match_color_and_position => 1}" do
      expect(Mastermind.new.format_counted_matches({:match_color_and_position=>1})).to eq('@')
    end

    it "outputs '@+.' when the input is {:match_color_and_position => 1, :match_color_not_position => 1, :no_match => 1}" do
      expect(Mastermind.new.format_counted_matches({:match_color_and_position=>1, :match_color_not_position=>1, :no_match=>1})).to eq('@+.')
    end

    it "outputs '@@@+....' when the input is {:match_color_and_position => 3, :match_color_not_position => 1, :no_match => 4}" do
      expect(Mastermind.new.format_counted_matches({:match_color_and_position=>3, :match_color_not_position=>1, :no_match=>4})).to eq('@@@+....')
    end

    it "outputs '@@..' when the input is {:match_color_and_position => 2, :match_color_not_position => 0, :no_match => 2}" do
      expect(Mastermind.new.format_counted_matches({:match_color_and_position=>2, :match_color_not_position=>0, :no_match=>2})).to eq('@@..')
    end
  end

  context "remembering match type counts" do
    it "finds 0 :match_color_and_position, 0 :match_color_not_position, 4 no_match when it receives an array of 4 :no_matches" do
      expect(Mastermind.new.count_matches([:no_match, :no_match, :no_match, :no_match]))
        .to eq({:match_color_and_position => 0, :match_color_not_position => 0, :no_match => 4})
    end

    it "finds 1 :match_color_and_position, 0 :match_color_not_position, 3 no_match when it receives an array of 1 :match_color_and_position and 3 :no_matches" do
      expect(Mastermind.new.count_matches([:match_color_and_position, :no_match, :no_match, :no_match]))
      .to eq({:match_color_and_position => 1, :match_color_not_position => 0, :no_match => 3})
    end

    it "finds 1 :match_color_and_position, 0 :match_color_not_position, 0 :no_match when it receives an array of 1 :match_color_and_position" do
      expect(Mastermind.new.count_matches([:match_color_and_position]))
      .to eq({:match_color_and_position => 1, :match_color_not_position => 0, :no_match => 0})
    end

    it "finds 1 :match_color_and_position, 0 :match_color_not_position, 0 :no_match when it receives an array of 1 :match_color_and_position" do
      expect(Mastermind.new.count_matches([:match_color_and_position]))
      .to eq({:match_color_and_position => 1, :match_color_not_position => 0, :no_match => 0})
    end

    context "testing input exception paths" do
      it "raises a InvalidInputException if an empty array is passed in" do
        expect{Mastermind.new.count_matches([])}.to raise_error(Mastermind::InvalidInputException)
      end

      it "raises a InvalidInputException if an incorrect array key is passed in" do
        expect{Mastermind.new.count_matches([:foobar])}.to raise_error(Mastermind::InvalidInputException)
      end

      it "raises a InvalidInputTypeException if a hash is passed in" do
        expect{Mastermind.new.count_matches({:no_match => 0})}.to raise_error(Mastermind::InvalidInputTypeException)
      end
    end
  end

  context "making guesses: 1 slot, 1 color" do
    it "outputs correct color and position when the guess is correct" do
      expect(Mastermind.new(MastermindSolution.new({:solution_choices => 'G', :solution_length => 1})).check('G')).to eq([:match_color_and_position])
    end

    it "outputs no match when the guess is incorrect" do
      expect(Mastermind.new(MastermindSolution.new({:solution_choices => 'G', :solution_length => 1})).check('R')).to eq([:no_match])
    end
  end

  context "making guesses: 2 slots, 4 colors" do
    it "outputs correct color and position when the guess is correct" do
      allow_any_instance_of(Array).to receive(:shuffle) { ['R', 'G'] }
      expect(Mastermind.new(MastermindSolution.new({:solution_choices => 'RG', :solution_length => 2})).check('RG')).to eq([:match_color_and_position, :match_color_and_position])
    end

    it "outputs no match when the guess is incorrect" do
      allow_any_instance_of(Array).to receive(:shuffle) { ['R', 'G'] }
      expect(Mastermind.new(MastermindSolution.new({:solution_choices => 'RG', :solution_length => 2})).check('BY')).to eq([:no_match, :no_match])
    end

    it "outputs partial matches when the guess is correct colours but wrong position" do
      allow_any_instance_of(Array).to receive(:shuffle) { ['R', 'G'] }
      expect(Mastermind.new(MastermindSolution.new({:solution_choices => 'RG', :solution_length => 2})).check('GR')).to eq([:match_color_not_position, :match_color_not_position])
    end

  end

  context "making guesses: 3 slots, 4 colors" do
    it "outputs [:match_color_not_position, :match_color_not_position, :match_color_not_position] when solution is 'RGR' and guess is 'GRG'" do
      allow_any_instance_of(Array).to receive(:shuffle) { ['R', 'G', 'B', 'Y'] }
      expect(Mastermind.new(MastermindSolution.new({:solution_choices => 'RGB', :solution_length => 3})).check('BRG')).to eq([:match_color_not_position, :match_color_not_position, :match_color_not_position])
    end
  end
end