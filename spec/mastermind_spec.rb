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

class Mastermind

  def initialize solution
    @solution = solution
    @solution_array = solution.split(//)
  end

  def check guess
    guess_array = guess.split(//)
    # 'RG' => ['R','G']
    # 'GG' => ['G', 'G']
    # if sol[0] == guess[0] results << :match_color_and_position

    # 1. set array to no match
    result_array = Array.new(guess_array.length, :no_match)

    # 2. check to see if colors exist
    guess_array.each_with_index do |guess_char,guess_index|
      if @solution_array.include?(guess_char) then
        result_array[guess_index] = :match_color_not_position
      end
    end

    # 3. check to see if colours are in correct positions
    guess_array.each_with_index do |guess_char,guess_index|
      if guess_char == @solution_array[guess_index] then
        result_array[guess_index] = :match_color_and_position
      end
    end

    result_array

  end

end

describe Mastermind do

  xit "///" do
    mastermind = Mastermind.new
    # mastermind.start
    ## mastermind.solution = mastermind.generate_solution
  end

  context "making guesses: 1 slot, 1 color" do
    it "outputs correct color and position when the guess is correct" do
      expect(Mastermind.new('G').check('G')).to eq([:match_color_and_position])
    end

    it "outputs no match when the guess is incorrect" do
      expect(Mastermind.new('G').check('R')).to eq([:no_match])
    end
  end

  context "making guesses: 2 slots, 2 colors" do
    it "outputs correct color and position when the guess is correct" do
      # :no_match, :match_color, :match_color_and_position
      # given: assuming solution = 'RG'
      # when mastermind.guess 'RG' =>
      # # then output shoudl be: [:match_color_and_position, :match_color_and_position]
      expect(Mastermind.new('RG').check('RG')).to eq([:match_color_and_position, :match_color_and_position])
    end

    it "outputs no match when the guess is incorrect" do
      expect(Mastermind.new('RR').check('GG')).to eq([:no_match, :no_match])
    end

    it "outputs partial matches when the guess is correct colours but wrong position" do
      expect(Mastermind.new('RG').check('GR')).to eq([:match_color_not_position, :match_color_not_position])
    end
  end

  context "making guesses: 2 slots, 3 colours" do
    it "outputs [:no_match, :match_color_not_position] when solution is 'RG' and guess is 'GB'" do
      expect(Mastermind.new('RG').check('GB')).to eq([:match_color_not_position, :no_match])
    end
  end
end