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

require 'mastermind_solution'

class Mastermind
  class DuplicateNotAllowedException < StandardError; end
  class InvalidInputException < StandardError; end
  class InvalidInputTypeException < StandardError; end

  def initialize solution=MastermindSolution.new({:solution_choices => 'R', :solution_length => 1})
    @solution = solution
  end

  def attempt guess
    format_counted_matches(count_matches(check(guess)))
  end

  # private

  def check guess
    guess_array = guess.split(//)

    # 1. set array to no match
    result_array = set_array_to_no_match(guess_array.length)
    result_array = Array.new(guess_array.length, :no_match)

    guess_array.each_with_index do |guess_char,guess_index|
      # 2. check to see if colours are in correct positions
      if guess_char == @solution.to_a[guess_index] then
        result_array[guess_index] = :match_color_and_position

        # change the solution index to a space, so we don't match it again
        @solution.to_a[guess_index] = ' '
      else
        # 3. check to see if colors exist
        if @solution.to_a.include?(guess_char) then
          result_array[guess_index] = :match_color_not_position
          solution_index_to_remove = @solution.to_a.index(guess_char)

          # change the solution index of the first character to match, to a space, so we don't match it again
          @solution.to_a[solution_index_to_remove] = ' '
        end
      end
    end

    result_array
  end

  def count_matches matches
    raise Mastermind::InvalidInputException if matches.empty?
    raise Mastermind::InvalidInputTypeException unless matches.is_a?(Array)

    count_of_matches = {:match_color_and_position => 0, :match_color_not_position => 0, :no_match => 0}

    matches.each do |match_type|
      count_of_matches[match_type] += 1 rescue raise Mastermind::InvalidInputException
    end

    count_of_matches
  end

  FORMAT_TEMPLATE = {:match_color_and_position => '@', :match_color_not_position => '+', :no_match => '.'}

  def format_counted_matches counted_matches
    counted_matches.map { |key,value| FORMAT_TEMPLATE[key]*value }.join
  end
end

describe Mastermind do

  # instantiate game
  # generate random solution
  # output STDIN cursor
  # receive STDIN
  # attempt solution
  # output result

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