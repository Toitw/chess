# frozen_string_literal: true

require_relative "board"
require_relative "piece"
require_relative "player"
require_relative "visual"

class Game
    attr_reader :board, :current_player, :player1, :player2, :selected_piece
    def initialize
        @board = nil
        @player1 = Player.new("Player1")
        @player2 = Player.new("Player2")
        @current_player = @player1
        @selected_piece = nil
    end

    def play
        puts "welcome"
        create_players
        start_animation
        @board = Board.new
        choose_origin
        check_origin
        puts "end"
    end

    def start_animation
        str = "Let's the game BEGINS!"
        str.split(" ").each do |word|
            puts "\n#{word}"
            sleep(1)
        end
    end

    def choose_origin #Gets only valid letter + number, store it as an array in @current_player.origin, raise an error if invalid
        puts "\n#{@current_player.name} Please, enter the coordinate of the piece you want to move (First a letter a-h, then a number 1-8, e.g. 'e4')"
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

    def create_players 
            puts "\n#{@current_player.name}, what is your name?"
            @current_player.name = gets.chomp
            puts "\nHello #{@current_player.name}, now choose with which color you play ('W' for whites, 'B' for blacks)"
            check_color
            change_current_player
            puts "\n#{@current_player.name}, what is your name?"
            @current_player.name = gets.chomp
            @player1.color == "White" ? @current_player.color = "Black" : @current_player.color = "White"
            puts "\n#{@current_player.name} you will play #{@current_player.color}"
            sleep(1)
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

    def check_origin
        if @board.board[@current_player.origin[0]][@current_player.origin[1]].nil?
            puts "There is no piece on that coordinate, please choose another one"
            choose_origin
        elsif @board.board[@current_player.origin[0]][@current_player.origin[1]].color != @current_player.color
            puts "That is not your piece! Please, choose one of your pieces to move"
            choose_origin
        else
            @selected_piece = @board.board[@current_player.origin[0]][@current_player.origin[1]]
        end
    end

    def get_all_moves(piece)
    end

    def game_loop
        choose_origin
        check_origin 
        get_all_moves #In creation
        get_available_moves #to be created
        choose_destination #to be created
        check_destination #to be created
        move_piece #to be created
        update_board #to be created
        change_current_player #to be created
    end 
      

end
