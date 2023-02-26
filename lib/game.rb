# frozen_string_literal: true

require_relative "board"
require_relative "piece"
require_relative "player"
require_relative "visual"

class Game
    attr_reader :board, :current_player
    def initialize
        @board = Board.new
        @player1 = Player.new("Player1")
        @player2 = Player.new("Player2")
        @current_player = @player1
    end

    def play
        puts "welcome"

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

    def create_players #This will be looped 2 times
        puts "#{@current_player.name}, what is your name?"
        @current_player.name = gets.chomp
        puts "Hello #{@current_player.name}, now choose with which color you play ('W' for whites, 'B' for blacks)"
        check_color
        change_current_player
    end

    def check_color #Check for valid input and store the color, raise an error if invalid
        begin
          color = gets.chomp
          if color.match?(/^[wW]$/)
            @current_player.color = "White"
          elsif color.match? (/^[bB]$/)
            @current_player.color= "Black"
          else
            raise "Please, write only 'B' for blacks or 'W' for whites"
          end
        rescue => e
          puts e.message
          retry
        end
    end

    def change_current_player
        @current_player == @player1 ? @current_player = @player2 : @current_player = @player1
    end
      

end
