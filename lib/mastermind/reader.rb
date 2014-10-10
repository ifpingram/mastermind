class Mastermind
  class Reader
    attr_reader :input_stream
    def initialize(input_stream=$stdin)
      @input_stream = input_stream
    end

    def receive_guess
      input_stream.gets.chomp
    end
  end
end