require 'mastermind/writer'

describe Mastermind::Writer do
  let(:stream) { StringIO.new }
  let(:writer) { Mastermind::Writer.new(stream) }
  it "should output the welcome text when it receives the welcome message" do
    writer.welcome
    stream.rewind
    expect(stream.read).to eq("Welcome to Mastermind!\nI have created a 4 character solution for you to guess, using the following colors:\nR -> Red\nG -> Green\nB -> Blue\nY -> Yellow\nO -> Orange\nType exit to quit\n")
  end

  it "should output the enter your guess prompt" do
    writer.prompt_for_guess
    stream.rewind
    expect(stream.read).to eq("Please enter your 4 character guess:\n")
  end

  it "should output that your guess was correct" do
    writer.guess_was_correct
    stream.rewind
    expect(stream.read).to eq("Congratulations! You guessed correctly!\n")
  end

  it "should output that your guess was incorrect" do
    writer.guess_was_incorrect('....')
    stream.rewind
    expect(stream.read).to eq("I'm sorry, you did not guess correctly. Here's your result: [....]\n")
  end

  it "should output that your guess was still incorrect" do
    writer.guess_was_incorrect('++..')
    stream.rewind
    expect(stream.read).to eq("I'm sorry, you did not guess correctly. Here's your result: [++..]\n")
  end

  it "should output that your guess was of the wrong data type" do
    writer.input_type_error
    stream.rewind
    expect(stream.read).to eq("You can only enter String data types\n")
  end

  it "should output that your guess was of the wrong length" do
    writer.input_length_error
    stream.rewind
    expect(stream.read).to eq("Please only enter a 4 character guess\n")
  end

  it "should output that your guess was using the wrong characters" do
    writer.input_character_error
    stream.rewind
    expect(stream.read).to eq("Please only use the following characters: RGBY\n")
  end

  it "should output 'Thank you for playing. Goodbye!'" do
    writer.goodbye
    stream.rewind
    expect(stream.read).to eq("Thank you for playing. Goodbye!\n")
  end
end