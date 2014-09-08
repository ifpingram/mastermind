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
  end

  def check guess
    [:match_color_and_position, :match_color_and_position]
  end

end

describe Mastermind do

  xit "///" do
    mastermind = Mastermind.new
    # mastermind.start
    ## mastermind.solution = mastermind.generate_solution
  end

  context "making guesses" do
    it "outputs correct color and position when the guess is correct" do
      # :no_match, :match_color, :match_color_and_position
      # given: assuming solution = 'RG'
      # when mastermind.guess 'RG' =>
      # # then output shoudl be: [:match_color_and_position, :match_color_and_position]
      expect(Mastermind.new('RG').check('RG')).to eq([:match_color_and_position, :match_color_and_position])
    end
  end

end