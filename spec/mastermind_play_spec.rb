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

describe MastermindPlay do
  # > ruby mastermind_play
  # "Welcome to Mastermind!"

  it "welcomes us to the game" do
    output = double('output_double')
    expect(output).to receive(:puts).with("Welcome to Mastermind!")
    MastermindPlay.new(output)
  end
end