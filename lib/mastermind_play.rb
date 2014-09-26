class MastermindPlay

  attr_reader :writer, :reader

  # http://blog.8thlight.com/josh-cheek/2011/10/01/testing-code-thats-hard-to-test.html
  def initialize(writer = Writer.new, reader = Reader.new)
    @writer = writer
    @reader = reader
  end

  def play
    mastermind = Mastermind.new
    writer.welcome
    writer.prompt_for_guess
    guess = reader.receive_guess
    mastermind.attempt(guess)
    writer.guess_was_correct
    writer.guess_was_incorrect

    # if mastermind.check(guess)
    # guess = reader.make_guess
    # if guess.correct?
    #   writer.declare_suces
    # else
    #     writer.declare_failure
    #     writer.offer_to_try_again
    #     guess = reader.make_guess
    # end

    # make_guess  #=?>  self.make_guess
    # other_object.make_guess => I'm sending 'make_guess' to other_object
    # self.make_guess => I'm sending 'make_guess' to myself
    # make_guess => the same
    # I expect that self will receive 'make_guess'
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
      output_stream.puts 'Please enter your 4 character guess:'
    end
  end

  class Reader

  end

  def make_guess
  #   guess = gets
  end
end


if __FILE__==$0
  MastermindPlay.new # this will only run if the script was the main, not load'd or require'd
end
