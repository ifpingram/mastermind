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
        expect(Mastermind.new(Mastermind::Writer, Mastermind::Reader, Mastermind::Solution.new({:solution => solution_attempt_output[0]})).is_guess_correct?(solution_attempt_output[1])).to eq(solution_attempt_output[2])
      end
      it "outputs '#{solution_attempt_output[3]}' when the solution is '#{solution_attempt_output[0]}' and the guess is '#{solution_attempt_output[1]}'" do
        mastermind = Mastermind.new(Mastermind::Writer, Mastermind::Reader, Mastermind::Solution.new({:solution => solution_attempt_output[0]}))
        mastermind.is_guess_correct?(solution_attempt_output[1])
        expect(mastermind.show_guess_result).to eq(solution_attempt_output[3])
      end
    end
  end

  context 'playing a game' do
    let(:writer_mock) { double('writer_mock').as_null_object }
    let(:reader_mock) { double('reader_mock').as_null_object }
    let(:solution_mock) { double('solution_mock').as_null_object }
    let(:game) { Mastermind.new(writer_mock, reader_mock, solution_mock) }

    before do
      allow(game).to receive(:is_guess_correct?).and_return(true)
    end

    it "welcomes us to a new game" do
      expect(writer_mock).to receive(:welcome)
      game.play
    end

    it "prompts for our first guess" do
      expect(writer_mock).to receive(:prompt_for_guess)
      game.play
    end

    it "receives a user guess" do
      expect(reader_mock).to receive(:receive_guess)
      game.play
    end

    it "attempts the guess against the Mastermind instance's solution" do
      expect(game).to receive(:is_guess_correct?)
      game.play
    end

    it "thanks us for playing" do
      expect(writer_mock).to receive(:goodbye)
      game.play
    end

    context "making a valid guess" do

      it "tells us our guess was correct" do
        allow(game).to receive(:is_guess_correct?).and_return(true)
        expect(writer_mock).to receive(:guess_was_correct)
        expect(writer_mock).to_not receive(:guess_was_incorrect)
        game.play
      end
    end

    context "making a invalid guess" do

      let(:guess_result) { 'foo' }

      it "tells us our guess was incorrect" do
        allow(game).to receive(:is_guess_correct?).exactly(2).times.and_return(false,true)
        allow(game).to receive(:show_guess_result).exactly(2).times.and_return(guess_result)
        expect(writer_mock).to receive(:guess_was_incorrect).exactly(1).times.with(guess_result)
        game.play
      end

      it "tells us to guess again" do
        expect(game).to receive(:make_guess).exactly(2).times.and_return(false, true)
        game.play
      end

      it "tells us to guess again and again and again" do
        expect(game).to receive(:make_guess).exactly(3).times.and_return(false, false, true)
        game.play
      end

      it "tells us to guess again and again and again and again and again and again and again" do
        expect(game).to receive(:make_guess).exactly(7).times.and_return(false, false, false, false, false, false, true)
        game.play
      end
    end

    context "error handling" do
      it "tells us that the guess was the wrong data type" do
        allow(game).to receive(:is_guess_correct?).and_raise(Mastermind::InvalidInputTypeException)
        expect(writer_mock).to receive(:input_type_error)
        game.play
      end

      it "tells us that the guess was the wrong length" do
        allow(game).to receive(:is_guess_correct?).and_raise(Mastermind::InvalidInputLengthException)
        expect(writer_mock).to receive(:input_length_error)
        game.play
      end

      it "tells us that the guess was using the wrong characters" do
        allow(game).to receive(:is_guess_correct?).and_raise(Mastermind::InvalidInputCharacterException)
        expect(writer_mock).to receive(:input_character_error)
        game.play
      end
    end
  end

  context "testing input exception paths" do
    let(:mastermind) {Mastermind.new(Mastermind::Writer, Mastermind::Reader, Mastermind::Solution.new({:choices => 'RGBY', :length => 4}))}

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

  xcontext "outputting friendly exception messages and continuing the game" do
    let(:mastermind) {Mastermind.new(Mastermind::Writer, Mastermind::Reader, Mastermind::Solution.new({:choices => 'RGBY', :length => 4}))}

    it "says  if an empty array is attempted" do
      expect{mastermind.is_guess_correct?([])}.to raise_error(Mastermind::InvalidInputTypeException)
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
  end

  context "making guesses: 1 slot, 1 color" do
    it "outputs correct color and position when the guess is correct" do
      expect(Mastermind.new(Mastermind::Writer, Mastermind::Reader, Mastermind::Solution.new({:solution => 'G', :length => 1})).check('G')).to eq([:match_color_and_position])
    end

    it "outputs no match when the guess is incorrect" do
      expect(Mastermind.new(Mastermind::Writer, Mastermind::Reader, Mastermind::Solution.new({:solution => 'G', :length => 1})).check('R')).to eq([:no_match])
    end
  end

  context "making guesses: 2 slots, 4 colors" do
    it "outputs correct color and position when the guess is correct" do
      allow_any_instance_of(Array).to receive(:shuffle) { ['R', 'G'] }
      expect(Mastermind.new(Mastermind::Writer, Mastermind::Reader, Mastermind::Solution.new({:choices => 'RG', :length => 2})).check('RG')).to eq([:match_color_and_position, :match_color_and_position])
    end

    it "outputs no match when the guess is incorrect" do
      allow_any_instance_of(Array).to receive(:shuffle) { ['R', 'G'] }
      expect(Mastermind.new(Mastermind::Solution.new({:choices => 'RG', :length => 2})).check('BY')).to eq([:no_match, :no_match])
    end

    it "outputs partial matches when the guess is correct colours but wrong position" do
      allow_any_instance_of(Array).to receive(:shuffle) { ['R', 'G'] }
      expect(Mastermind.new(Mastermind::Writer, Mastermind::Reader, Mastermind::Solution.new({:choices => 'RG', :length => 2})).check('GR')).to eq([:match_color_not_position, :match_color_not_position])
    end

  end

  context "making guesses: 3 slots, 4 colors" do
    it "outputs [:match_color_not_position, :match_color_not_position, :match_color_not_position] when solution is 'RGR' and guess is 'GRG'" do
      allow_any_instance_of(Array).to receive(:shuffle) { ['R', 'G', 'B', 'Y'] }
      expect(Mastermind.new(Mastermind::Writer, Mastermind::Reader, Mastermind::Solution.new({:choices => 'RGB', :length => 3})).check('BRG')).to eq([:match_color_not_position, :match_color_not_position, :match_color_not_position])
    end
  end
end