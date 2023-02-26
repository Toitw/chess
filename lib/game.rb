# frozen_string_literal: true

require_relative "board"
require_relative "piece"
require_relative "player"
require_relative "visual"

class Game
    attr_reader :board
    def initialize
        @board = Board.new
        @player1 = Player.new
        @player2 = Player.new
        @current_player = nil
    end

    def choose_origin #Gets only valid letter + number, store it as an array in @current_player.origin, raise an error if invalid
        begin
            raw_input = gets.chomp
            if raw_input[0].match?(/^[a-hA-H]$/) == false || raw_input[1].match?(/^[1-8]$/) == false
              raise "Invalid input: '#{raw_input}'. Please enter a valid chess coordinate (First a letter a-h, then a number 1-8, e.g. 'e4')"
            else
              @current_player.origin = [(raw_input[0].downcase.ord - 97), raw_input[1].to_i]
            end
            rescue => e
                puts e.message
            retry
        end
    end
end
