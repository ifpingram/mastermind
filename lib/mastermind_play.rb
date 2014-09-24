class MastermindPlay
  def initialize(output_stream = STDOUT)
    output_stream.puts "Welcome to Mastermind!"
  end
end


if __FILE__==$0
  MastermindPlay.new # this will only run if the script was the main, not load'd or require'd
end
