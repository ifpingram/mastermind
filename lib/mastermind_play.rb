class MastermindPlay

  attr_reader :writer, :reader, :mastermind

  # http://blog.8thlight.com/josh-cheek/2011/10/01/testing-code-thats-hard-to-test.html
  def initialize(writer = Writer.new, reader = Reader.new)
    @writer = writer
    @reader = reader
    @mastermind = Mastermind.new
  end

  def make_guess
    writer.prompt_for_guess
    guess = reader.receive_guess
    if mastermind.is_guess_correct?(guess)
      writer.guess_was_correct
      return true
    else
      writer.guess_was_incorrect(mastermind.show_guess_result) # show_guess_result => '....', '+@.+'
      return false
    end
  end

  def play
    writer.welcome

    guess_result = false

    until guess_result
      guess_result = make_guess
    end

    writer.goodbye
  end

  class Writer
    attr_reader :output_stream
    def initialize(output_stream=$stdout)
      @output_stream = output_stream
    end

    def welcome
      output_stream.puts "Welcome to Mastermind!"
      output_stream.puts 'I have created a 4 character solution for you to guess, using the following colors:'
      output_stream.puts 'R -> Red'
      output_stream.puts 'G -> Green'
      output_stream.puts 'B -> Blue'
      output_stream.puts 'Y -> Yellow'
      output_stream.puts 'O -> Orange'
    end

    def prompt_for_guess
      output_stream.puts 'Please enter your 4 character guess:'
    end

    def guess_was_correct
      output_stream.puts 'Congratulations! You guessed correctly!'
    end

    def guess_was_incorrect result_output
      output_stream.puts "I'm sorry, you did not guess correctly. Here's your result: [#{result_output}]"
    end

    def goodbye
      output_stream.puts 'Thank you for playing. Goodbye!'
    end
  end

  class Reader

  end
end


if __FILE__==$0
  MastermindPlay.new # this will only run if the script was the main, not load'd or require'd
end
