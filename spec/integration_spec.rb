require 'mastermind'

class IOInspector
  attr_reader :cumulative_output

  def puts(data)
    @cumulative_output ||= ''
    @cumulative_output << data
  end

end

class MultiInputReader

  def initialize(inputs)
    @inputs = inputs << 'exit'
  end

  def gets
    @inputs.shift
  end
end

describe Mastermind do

  context 'playing a game with full collaborators' do
    it "plays a full game" do
      reader_stream = StringIO.new('RGBY')
      writer_stream = StringIO.new # IOInspector.new
      game = Mastermind.new(Mastermind::Writer.new(writer_stream), Mastermind::Reader.new(reader_stream), Mastermind::Solution.new({:solution => 'RGBY'}))

      game.play
      writer_stream.rewind
      expect(writer_stream.read).to include('Congratulations')
    end

    it "plays a full game" do
      reader_stream = MultiInputReader.new(['RGBO'])
      writer_stream = StringIO.new # IOInspector.new
      game = Mastermind.new(Mastermind::Writer.new(writer_stream), Mastermind::Reader.new(reader_stream), Mastermind::Solution.new({:solution => 'RGBY'}))

      game.play
      writer_stream.rewind
      output = writer_stream.read
      expect(output).to include('sorry')
    end

    it "plays a game with an incorrect length guess" do
      reader_stream = MultiInputReader.new(['RGBYO', 'RGBY'])
      writer_stream = StringIO.new
      game = Mastermind.new(Mastermind::Writer.new(writer_stream), Mastermind::Reader.new(reader_stream), Mastermind::Solution.new({:solution => 'RGBY'}))

      game.play
      writer_stream.rewind
      output = writer_stream.read
      expect(output).to include('Please only enter a 4 character guess')
      expect(output).to include('Congratulations')
    end

  end
end