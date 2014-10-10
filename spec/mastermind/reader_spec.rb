require 'mastermind/reader'

describe Mastermind::Reader do

  it "receives a guess" do
    stream = StringIO.new('abcd')
    reader = Mastermind::Reader.new(stream)
    expect(reader.receive_guess).to eq('abcd')
  end

  it "chomps the guess" do
    stream = StringIO.new("abcd\n")
    reader = Mastermind::Reader.new(stream)
    expect(reader.receive_guess).to eq('abcd')
  end
end