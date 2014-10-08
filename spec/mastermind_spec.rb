require 'mastermind'

describe Mastermind do

  context "allow duplicates in the solution" do
    [ # solution, attempt, success?, output
     ['RRRR','RRRR',true,'@@@@'],
     ['RRRB','RRRY',false,'@@@.'],
     ['BRRR','YRRR',false,'@@@.'],
     ['BRYR','YRYR',false,'@@+.'],
     ['RGRY','RGBB',false,'@@..'],
     ['RGRY','RBBB',false,'@...'],
     ['RRBO','RRYB',false,'@@+.'],
     ['RGBY','RBYO',false,'@++.'],
     ['RGBY','YRGB',false,'++++'],
     ['RGBY','YRGO',false,'+++.'],
     ['RGBY','GROA',false,'++..'],
     ['RGBY','ACDE',false,'....'],
    ].each do |solution_attempt_output|
      it "outputs '#{solution_attempt_output[2]}' when the solution is '#{solution_attempt_output[0]}' and the guess is '#{solution_attempt_output[1]}'" do
        expect(Mastermind.new(MastermindSolution.new({:solution => solution_attempt_output[0]})).is_guess_correct?(solution_attempt_output[1])).to eq(solution_attempt_output[2])
      end
      it "outputs '#{solution_attempt_output[3]}' when the solution is '#{solution_attempt_output[0]}' and the guess is '#{solution_attempt_output[1]}'" do
        mastermind = Mastermind.new(MastermindSolution.new({:solution => solution_attempt_output[0]}))
        mastermind.is_guess_correct?(solution_attempt_output[1])
        expect(mastermind.show_guess_result).to eq(solution_attempt_output[3])
      end
    end
  end

  context "testing input exception paths" do
    let(:mastermind) {Mastermind.new(MastermindSolution.new({:solution_choices => 'RGBY', :solution_length => 4}))}

    it "raises a InvalidInputTypeException if an empty array is attempted" do
      expect{mastermind.is_guess_correct?([])}.to raise_error(Mastermind::InvalidInputTypeException)
    end

    it "raises a InvalidInputLengthException if an incorrect attempt length is used" do
      expect{mastermind.is_guess_correct?('RRR')}.to raise_error(Mastermind::InvalidInputLengthException)
    end

    it "raises a InvalidInputCharacterException if an incorrect attempt character is used" do
      expect{mastermind.is_guess_correct?('RBOP')}.to raise_error(Mastermind::InvalidInputCharacterException)
    end
  end

  xcontext "outputting formatted counted matches" do
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

  xcontext "remembering match type counts" do
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
  end

  xcontext "making guesses: 1 slot, 1 color" do
    it "outputs correct color and position when the guess is correct" do
      expect(Mastermind.new(MastermindSolution.new({:solution_choices => 'G', :solution_length => 1})).check('G')).to eq([:match_color_and_position])
    end

    it "outputs no match when the guess is incorrect" do
      expect(Mastermind.new(MastermindSolution.new({:solution_choices => 'G', :solution_length => 1})).check('R')).to eq([:no_match])
    end
  end

  xcontext "making guesses: 2 slots, 4 colors" do
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

  xcontext "making guesses: 3 slots, 4 colors" do
    it "outputs [:match_color_not_position, :match_color_not_position, :match_color_not_position] when solution is 'RGR' and guess is 'GRG'" do
      allow_any_instance_of(Array).to receive(:shuffle) { ['R', 'G', 'B', 'Y'] }
      expect(Mastermind.new(MastermindSolution.new({:solution_choices => 'RGB', :solution_length => 3})).check('BRG')).to eq([:match_color_not_position, :match_color_not_position, :match_color_not_position])
    end
  end
end