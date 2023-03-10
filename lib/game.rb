# frozen_string_literal: true

require_relative "board"
require_relative "piece"
require_relative "player"
require_relative "visual"
require_relative "chessPieceMoves"

class Game
    include ChessPieceMoves

    attr_reader :board, :current_player, :player1, :player2, :selected_piece, :available_moves
    def initialize
        @board = Board.new
        @player1 = Player.new("Player1")
        @player2 = Player.new("Player2")
        @current_player = @player1
        @selected_piece = nil
        @available_moves = nil
    end

    def display_board
        @board.display_board
    end

    def play
        puts "welcome"
        create_players
        start_animation
        loop do
            game_loop
        end
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
                @current_player.origin = [(raw_input[0].downcase.ord - 97), (raw_input[1].to_i)-1]
                end
                rescue => e
                    puts e.message
                retry
            end
    end

    def create_players #check, it doesn't apply the right color
            puts "\n#{@current_player.name}, what is your name?"
            @current_player.name = gets.chomp
            puts "\nHello #{@current_player.name}, now choose with which color you play ('W' for whites, 'B' for blacks)"
            check_color
            change_current_player
            puts "\n#{@current_player.name}, what is your name?"
            @current_player.name = gets.chomp
            #check, it doesn't apply the right color
            @player1.color == "white" ? @current_player.color = "black" : @current_player.color = "white"
            puts "\n#{@current_player.name} you will play #{@current_player.color}"
            change_current_player
            sleep(1)
    end

    def check_color #Check for valid input and store the color, raise an error if invalid
        begin
          color = gets.chomp
          if color.match?(/^[wW]$/)
            @current_player.color = "white"
          elsif color.match? (/^[bB]$/)
            @current_player.color= "black"
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
        elsif @board.board[@current_player.origin[0]][@current_player.origin[1]].color != @current_player.color.to_sym
            puts "That is not your piece! Please, choose one of your pieces to move"
            choose_origin
        else
            @selected_piece = @board.board[@current_player.origin[0]][@current_player.origin[1]]
        end
    end

    def get_all_moves(piece_type, pos) #Gets all the posible moves inside the board, ignoring pieces
        case piece_type
        when :knight
            moves = KNIGHT_MOVES.map { |column, row| [(pos[0] + column), (pos[1] + row)] }.filter { |column, row| column >= 1 && column <= 7 && row >= 1 && row <= 7 }
            moves
        when :bishop
            bishop_moves(pos)
        when :rook
            rook_moves(pos)
        when :queen
            queen_moves(pos)
        when :king
            king_moves(pos)
        when :pawn
            pawn_moves(pos, @selected_piece.color)
        end
    end
    #TO BE DONE: Add an option when #get_all_moves returns []
    def get_available_moves(piece_type, all_moves) #Gets the available legal moves
        @available_moves = all_moves.select do |column, row|
            @board.board[column][row] == nil || @board.board[column][row].color != @current_player.color.to_sym
        end
    end

    def choose_destination
        puts "\n#{@current_player.name} Please, enter the coordinate where you want to move the selected piece (First a letter a-h, then a number 1-8, e.g. 'e4')"
        begin
            raw_input = gets.chomp
            if raw_input[0].match?(/^[a-hA-H]$/) == false || raw_input[1].match?(/^[1-8]$/) == false
            raise "Invalid input: '#{raw_input}'. Please enter a valid chess coordinate (First a letter a-h, then a number 1-8, e.g. 'e4')"
            else
            @current_player.destination = [(raw_input[0].downcase.ord - 97), (raw_input[1].to_i)-1]
                #if input is good, it checks in the available moves. If it is one of them, breaks, if not, send a message
                if @available_moves.include?(@current_player.destination)
                    return
                else
                    raise "Invalid move. Please choose a valid destination."
                end
            end
            rescue => e
                puts e.message
            retry
        end
    end

    def move_selected_piece
        @board.board[@current_player.destination[0]][@current_player.destination[1]] = @selected_piece
        @board.board[@current_player.origin[0]][@current_player.origin[1]] = nil
    end

    def game_loop
        display_board
        choose_origin
        check_origin 
        get_available_moves(@selected_piece.type, get_all_moves(@selected_piece.type, @current_player.origin)) #In creation//TO BE DONE: Add an option when #get_all_moves returns []
        choose_destination 
        #check_destination #to be created
        move_selected_piece
        display_board
        #update_board #to be created
        change_current_player 
    end 
      

end
