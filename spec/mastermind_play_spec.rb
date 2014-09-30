# http://www.web-games-online.com/mastermind/
#
# Mastermind.
#
# So the idea is: start out with two pegs, two colors: RG:  RR GG RG GR
#
# There are four color pieces: [R]ed, [G]reen, [B]lue, [Y]ellow
#
# You start the ruby executable.
#
# The program creates a random four pieces and hides them.
#
# You then enter your guess as four letters:  RGRG  (red-green-red-green)
#
# The output is then: dot=none, +=match but wrong slot, @=match and slot.
# These are output in order: @’s, then +’s, then .’s.
# They don’t necessarily match the order of the entry
#
# So: Assuming the system chose: RGRY
#
# > BBBB => ....
# > RBBR => @+.. 
# > GRYR => ++++
# > GGRY => @@@.
# > RGRY => @@@@
#
# Congrats!
#
# (once you get a match, it shows it and how many steps)
#
# Bonus: choose from possible # pieces. defaults to 4 but could be: 2 - 8:
#
# Red, Green, Blue, Yellow, Orange, White, Purple, Cyan, Violet.
#
# It should start by showing the lexicon.
# ‘h’ should be treated as help and should show the lexicon.
# ‘q’ should be quit

###
# instantiate game
# generate random solution
# output STDIN cursor
# receive STDIN
# attempt solution
# output result


# puts "Hello! Welcome to Mastermind!"
# puts "Would you like to play a new game? (Y/N) "
# gets answer
# check_answer(answer)
# if answer == 'Y' then
# Mastermind.new...
# else
# puts "Sorry to hear that. Maybe next time!"

require 'mastermind_play'
require 'mastermind'

describe MastermindPlay do

  context 'playing a game' do
    let(:writer_mock) { double('writer_mock').as_null_object }
    let(:reader_mock) { double('reader_mock').as_null_object }
    let(:game) { MastermindPlay.new(writer_mock, reader_mock) }
    let(:mastermind) { double('mastermind_mock').as_null_object }

    before do
      allow(Mastermind).to receive(:new).and_return(mastermind)
    end

    it "creates a new Mastermind object" do
      expect(Mastermind).to receive(:new)
      game.play
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
      expect(mastermind).to receive(:is_guess_correct?) #.with('RGBY').and_return(true)
      game.play
    end

    context "making a valid guess" do

      it "tells us our guess was correct" do
        allow(mastermind).to receive(:is_guess_correct?).and_return(true)
        expect(writer_mock).to receive(:guess_was_correct)
        expect(writer_mock).to_not receive(:guess_was_incorrect)
        game.play
      end
    end

    context "making a invalid guess" do

      let(:guess_result) { 'foo' }

      it "tells us our guess was incorrect" do
        allow(mastermind).to receive(:is_guess_correct?).exactly(2).times.and_return(false,true)
        allow(mastermind).to receive(:show_guess_result).exactly(2).times.and_return(guess_result)
        expect(writer_mock).to receive(:guess_was_incorrect).exactly(1).times.with(guess_result)
        game.play
      end

      it "tells asks us to guess again" do
        expect(game).to receive(:make_guess).exactly(2).times.and_return(false, true)
        game.play
      end

      it "tells asks us to guess again and again and again" do
        expect(game).to receive(:make_guess).exactly(3).times.and_return(false, false, true)
        game.play
      end

      it "tells asks us to guess again and again and again and again and again and again and again" do
        expect(game).to receive(:make_guess).exactly(7).times.and_return(false, false, false, false, false, false, true)
        game.play
      end
    end
  end
  # > ruby mastermind_play
  # "Welcome to Mastermind!"
  # "I have created a 4 character solution for you to guess, using the following colors:"
  # "R -> Red"
  # "G -> Green"
  # "B -> Blue"
  # "Y -> Yellow"
  # "O -> Orange"
  # "Please enter your 4 character guess:"
  # "____" -> STDIN

  # do something
  # I introspect on a result
  # or I set up an expectation before doing something

  # it "welcomes us to the game" do
  #   # output = double('output_double')
  #   # expect(output).to receive(:puts).with('Welcome to Mastermind!')
  #   # expect(output).to receive(:puts).with('I have created a 4 character solution for you to guess, using the following colors:')
  #   # expect(output).to receive(:puts).with('R -> Red')
  #   # expect(output).to receive(:puts).with('G -> Green')
  #   # expect(output).to receive(:puts).with('B -> Blue')
  #   # expect(output).to receive(:puts).with('Y -> Yellow')
  #   # expect(output).to receive(:puts).with('O -> Orange')
  #   # expect(output).to receive(:puts).with('Please enter your 4 character guess:')
  #   # output = double('output_double')
  #   game = MastermindPlay.new # setup
  #   expect_any_instance_of(MastermindPlay::Writer).to receive(:welcome) # expectation
  #   game.play # execution
  # end
  #
  # it "asks for a guess input of 4 characters" do
  #   game = MastermindPlay.new
  #   expect(game).to receive(:make_guess)
  #   game.play
  # end

  # make_guess:
  # receive input from stdin
  # possibly clean
end