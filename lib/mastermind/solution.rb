class Mastermind
  class Solution

    attr_reader :choices, :original
    attr_accessor :modifiable

    def initialize params
      if params[:solution]
        @choices = ('A'..'Z').to_a
        @original = @modifiable = String.new(params[:solution]).split(//)
      else
        @choices = params[:choices].split(//)
        @original = @modifiable = @choices.shuffle.slice(0,params[:length])
      end
    end

    def check_if_color_matches_position guess_char, guess_index
      modifiable[guess_index] == guess_char
    end

    def check_if_color_exists guess_char
      modifiable.include?(guess_char)
    end

    def mark_index_as_matched index_value
      modifiable[index_value] = ' '
    end

    def mark_first_index_as_matched guess_char
      solution_index_to_remove = modifiable.to_a.index(guess_char)
      modifiable[solution_index_to_remove] = ' '
    end

    def to_a
      modifiable
    end

    def to_s
      modifiable.join.to_s
    end
  end
end