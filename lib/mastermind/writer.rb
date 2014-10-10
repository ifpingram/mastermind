class Mastermind::Writer

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
end