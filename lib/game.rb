# frozen_string_literal: true

require_relative "board"
require_relative "piece"
require_relative "player"
require_relative "visual"
require_relative "chessPieceMoves"
require "yaml"
require "tty-prompt"
require 'psych'

class Psych::Nodes::Scalar
    attr_accessor :anchor, :alias
  
    def yaml(opts = {})
      if self.alias
        "*#{@alias}"
      elsif @anchor
        "&#{@anchor} #{super}"
      else
        super
      end
    end
end

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
        @prompt = TTY::Prompt.new
    end

    def display_board
        @board.display_board
    end

    def play
        puts "welcome to chess. Press 1 to play a new game and 2 to load a previous game"
        selection = gets.chomp
        if selection == "1"
            create_players
            start_animation
            loop do
                game_loop
                if game_over?(@current_player.color.to_sym) == true
                    puts "\n Game Over! #{@current_player.name} wins."
                    break
                end
            end
            play_again?
        elsif selection == "2"
            display_files
        else
            play
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
                if raw_input == "HELP"
                    help_menu
                    board.display_board
                elsif raw_input[0].match?(/^[a-hA-H]$/) == false || raw_input[1] == nil || raw_input[1].match?(/^[1-8]$/) == false
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
            return false
        elsif @board.board[@current_player.origin[0]][@current_player.origin[1]].color != @current_player.color.to_sym
            puts "That is not your piece! Please, choose one of your pieces to move"
            return false
        end
        @selected_piece = @board.board[@current_player.origin[0]][@current_player.origin[1]]
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
                    @current_player.destination = []
                    raise "Invalid move. Please choose a valid destination."
                end
            end
            rescue => e
                puts e.message
            retry
        end
    end

    def move_selected_piece(board)
        board[@current_player.destination[0]][@current_player.destination[1]] = @selected_piece
        board[@current_player.origin[0]][@current_player.origin[1]] = nil
    end

    def move_back_selected_piece(board)
        board[@current_player.origin[0]][@current_player.origin[1]] = @selected_piece
        board[@current_player.destination[0]][@current_player.destination[1]] = nil
    end

    def in_check?(king_position)
        in_check = check_knight_attacks(king_position) || check_pawn_attacks(king_position) || check_vertical_lateral_attacks(king_position) || check_diagonal_attacks(king_position) || check_king_attacks(king_position)
    end
      
    def warn_player_check
        puts "Warning! Your king is in check. Choose your move wisely to protect your king."
    end
    
    def warn_opponent_check
        puts "Good move! Your opponent's king is in check."
    end
    
    def king_belongs_to_current_player?(king_position)
        x, y = king_position
        king_piece = @board.board[x][y]
        king_piece.type == :king && king_piece.color == @current_player.color.to_sym
    end
      

    def king_position #returns an array with the coordinates of current_player king
        king_position = []
        @board.board.each_with_index do |row, i|
            row.each_with_index do |piece, j|
            next if piece.nil?
            if piece.type == :king && piece.color == @current_player.color.to_sym
                king_position << [i, j]
            end
            end
        end
        king_position.flatten
    end

    def check_vertical_lateral_attacks(king_position)
        vert_lat_moves = []
        #right lateral
        x, y = king_position[0], king_position[1]
        until x >= 7
            x += 1
            if !@board.board[x][y].nil?
                break
            end
        end
        vert_lat_moves << [x, y]

        #left lateral
        x, y = king_position[0], king_position[1]
        until x <= 0
            x -= 1
            if !@board.board[x][y].nil?
                break
            end
        end
        vert_lat_moves << [x, y]

        #up vertical
        x, y = king_position[0], king_position[1]
        until y >= 7
            y += 1
            if !@board.board[x][y].nil?
                break
            end
        end
        vert_lat_moves << [x, y]

        #down vertical
        x, y = king_position[0], king_position[1]
        until y <= 0
            y -= 1
            if !@board.board[x][y].nil?
                break
            end
        end
        vert_lat_moves << [x, y]

        vert_lat_moves.each do |coord|
            next if @board.board[coord[0]][coord[1]].nil?
            return true if @board.board[coord[0]][coord[1]].type == :queen && @board.board[coord[0]][coord[1]].color != @current_player.color.to_sym ||  @board.board[coord[0]][coord[1]].type == :rook && @board.board[coord[0]][coord[1]].color != @current_player.color.to_sym
        end

        false
    end

    def check_knight_attacks(king_position)
        KNIGHT_MOVES.each do |column, row|
            x, y = king_position[0] + column, king_position[1] + row
            next unless (0..7).include?(x) && (0..7).include?(y)
            next if @board.board[x][y].nil?
            piece = @board.board[x][y].type
            color = @board.board[x][y].color
            return true if piece == :knight && color != @current_player.color.to_sym
        end

        false
    end

    def check_pawn_attacks(king_position) #Revisar si mueve rey al lado de peon no salta check
        if @current_player.color.to_sym == :white
            black_threats = [[1, 1], [-1, 1]]
            threat_position = black_threats.map {|pos| [pos[0] + king_position[0],pos[1] + king_position[1]]}
            threat_position.each do |coord|
                next if @board.board[coord[0]][coord[1]].nil?
                return true if @board.board[coord[0]][coord[1]].type == :pawn && @board.board[coord[0]][coord[1]].color != @current_player.color.to_sym
            end
        else
            white_threats = [[-1, -1], [1, -1]]
            threat_position = white_threats.each {|pos| [pos[0] + king_position[0],pos[1] + king_position[1]]}
            threat_position.each do |coord|
                next if @board.board[coord[0]][coord[1]].nil?
                return true if @board.board[coord[0]][coord[1]].type == :pawn && @board.board[coord[0]][coord[1]].color.to_sym != @current_player.color.to_sym
            end
        end

        false
    end

    def check_diagonal_attacks(king_position)
        diagonal_moves = []
        
        # Top-right diagonal
        x, y = king_position[0], king_position[1]
        until x >= 7 || y >= 7
          x += 1
          y += 1
          if !@board.board[x][y].nil?
            break
          end
        end
        diagonal_moves << [x, y]
      
        # Top-left diagonal
        x, y = king_position[0], king_position[1]
        until x <= 0 || y >= 7
          x -= 1
          y += 1
          if !@board.board[x][y].nil?
            break
          end
        end
        diagonal_moves << [x, y]
      
        # Bottom-left diagonal
        x, y = king_position[0], king_position[1]
        until x <= 0 || y <= 0
          x -= 1
          y -= 1
          if !@board.board[x][y].nil?
            break
          end
        end
        diagonal_moves << [x, y]
      
        # Bottom-right diagonal
        x, y = king_position[0], king_position[1]
        until x >= 7 || y <= 0
          x += 1
          y -= 1
          if !@board.board[x][y].nil?
            break
          end
        end
        diagonal_moves << [x, y]
      
        diagonal_moves.each do |coord|
          next if @board.board[coord[0]][coord[1]].nil?
          return true if @board.board[coord[0]][coord[1]].type == :queen && @board.board[coord[0]][coord[1]].color != @current_player.color.to_sym || @board.board[coord[0]][coord[1]].type == :bishop && @board.board[coord[0]][coord[1]].color != @current_player.color.to_sym
        end
      
        false
      end

    def check_king_attacks(king_position)
        king_moves = [
            [-1,  1], [0,  1], [1,  1],
            [-1,  0],           [1,  0],
            [-1, -1], [0, -1], [1, -1]
        ]
        
        king_moves.each do |move|
            x, y = king_position[0] + move[0], king_position[1] + move[1]
        
            # Skip if the position is outside the board
            next if x < 0 || x > 7 || y < 0 || y > 7
        
            piece = @board.board[x][y]
            next if piece.nil?
        
            if piece.type == :king && piece.color != @current_player.color.to_sym
            return true
            end
        end
        
        false
    end

    #game_over methods
    def game_over?(current_player_color)
        checkmate?(current_player_color) || insufficient_materials? #|| threefold_repetition? || fifty_move_rule?
    end

    def find_pieces_by_color(color)
        board = @board.board
        pieces = []
        board.each_with_index do |column, column_index|
            column.each_with_index do |piece, row_index|
              if piece && piece.color == color
                pieces << {
                  coordinates: [column_index, row_index],
                  type: piece.type
                }
              end
            end
        end
        
        pieces
    end

    def deep_copy_board(board) #this is to create a deep copy of board to use in checkmate?
        board.map { |row| row.dup }
      end
      

    def checkmate?(current_player_color)
        find_pieces_by_color(current_player_color).each do |piece_info| 
            position = piece_info[:coordinates]
            piece_type = piece_info[:type]
            @selected_piece = @board.board[position[0]][position[1]]
            # Make the move
            get_available_moves(piece_type, get_all_moves(piece_type, position)).each do |move| #revisar, coge moves negativos del rey y los movimientos de los peones están mal
                simulated_board = deep_copy_board(@board.board)
                @current_player.destination = move
                @current_player.origin = position
                move_selected_piece(simulated_board)
                # Check if the king is in check
                if in_check?(king_position) == true
                    true
                else
                    return false
                end
            end
        end
        true
    end

    def insufficient_materials?
        white_pieces = find_pieces_by_color(:white)
        black_pieces = find_pieces_by_color(:black)
    
        return true if only_kings?(white_pieces, black_pieces)
        return true if king_and_bishops_only?(white_pieces, black_pieces)
        return true if king_and_knights_only?(white_pieces, black_pieces)
    
        false
    end
    
    def only_kings?(white_pieces, black_pieces)
        white_pieces.count == 1 && black_pieces.count == 1 &&
        white_pieces.first[:type] == :king && black_pieces.first[:type] == :king
    end
    
    
    def king_and_bishops_only?(white_pieces, black_pieces)
        all_pieces = white_pieces + black_pieces
        return false unless all_pieces.all? { |piece| [:king, :bishop].include?(piece[:type]) }
    
        white_bishops = white_pieces.select { |piece| piece[:type] == :bishop }
        black_bishops = black_pieces.select { |piece| piece[:type] == :bishop }
    
        white_bishops_on_same_color = same_color_squares?(white_bishops)
        black_bishops_on_same_color = same_color_squares?(black_bishops)
    
        white_bishops_on_same_color && black_bishops_on_same_color
    end
    
    def king_and_knights_only?(white_pieces, black_pieces)
        all_pieces = white_pieces + black_pieces
        all_pieces.all? { |piece| [:king, :knight].include?(piece[:type]) }
    end
    
    def same_color_squares?(bishops)
        return true if bishops.empty?
    
        first_square_color = square_color(bishops.first[:coordinates])
        bishops.all? { |bishop| square_color(bishop[:coordinates]) == first_square_color }
    end
    
    
    def square_color(coordinates)
        x, y = coordinates
        (x + y) % 2 == 0 ? :light : :dark
    end   
    
    #Game loop
    def origin_destination_loop
        choose_origin
        while check_origin == false
            choose_origin
        end
        get_available_moves(@selected_piece.type, get_all_moves(@selected_piece.type, @current_player.origin))
        choose_destination
        move_selected_piece(@board.board)
    end 

    def game_loop
        display_board
        if in_check?(king_position)
            warn_player_check
        end
        origin_destination_loop
        while in_check?(king_position)
            warn_player_check
            move_back_selected_piece(@board.board)
            origin_destination_loop
        end
        display_board
        change_current_player 
    end 

    def play_again?
        puts "\n Would you like to play again? Y/N"
        answer = gets.chomp
        if answer == "Y"
            Game.new.play
        else
            puts "\n Thank you for playing"
        end
    end
    
    #Help menu methods, save, load and retry
    #Help menu
    def help_menu
        puts "\n Write the number of the option you would like"
        puts "\n 1 - Save game"
        puts "\n 2 - Restart"
        puts "\n 3 - Back to game"
        puts "\n 4 - Back to game"
        selection = gets.chomp
        if selection == "1"
            save_game(file_name)
        elsif selection == "2"
            Game.new.play
        else
            return
        end
    end

    #Save
    def save_game(file_name)
        board_data = @board.board.map do |row|
          row.map do |cell|
            if cell.nil?
              nil
            else
              { type: cell.type, color: cell.color }
            end
          end
        end
        
        current_player_alias = @current_player == @player1 ? "player1" : "player2"

        game_data = {
            board: board_data,
            player1: @player1,
            player2: @player2,
            current_player: {
              alias: current_player_alias
            }
        }
        
      
        folder_name = "saved_games"
        Dir.mkdir(folder_name) unless File.exists?(folder_name)
      
        file_path = File.join(folder_name, file_name)
        File.open(file_path, 'w') do |file|
          file.write(YAML.dump(game_data))
        end
        puts "Game saved to #{file_path}" #CUANDO SE GUARDA, LUEGO NO PUEDES METER HELP OTRA VEZ, REVISAR
    end


    def file_name
        puts "\n Please, write a name for your game"
        file_name = gets.chomp
        file_name
    end

    #Load
    def load_game(file_name)

    # Whitelist the Player, Symbol and Board classes for YAML loading, otherwise was not working
    permitted_classes = [Player, Board, Symbol]
    
    game_data = YAML.safe_load(File.read(file_name), permitted_classes: permitted_classes)

    # Update the current game's data with the loaded game's data
    board_data = game_data[:board]
    #Reconstructed board, otherwise got an error
    reconstructed_board = Board.new
    reconstructed_board.board = board_data.map do |row|
        row.map do |cell|
        if cell.nil?
            nil
        else
            Piece.new(cell[:type], cell[:color].to_sym)
        end
        end
    end

    # Reconstruct the player objects
    player1_data = game_data[:player1]
    @player1 = Player.new(player1_data.name, player1_data.color.to_sym)
    @player1.origin = player1_data.origin
    @player1.destination = player1_data.destination

    player2_data = game_data[:player2]
    @player2 = Player.new(player2_data.name, player2_data.color.to_sym)
    @player2.origin = player2_data.origin
    @player2.destination = player2_data.destination

    @board = reconstructed_board
    @player1 = game_data[:player1]
    @player2 = game_data[:player2]
    # Resolve the alias for the current_player
    if game_data[:current_player][:alias] == "player1"
        @current_player = @player1
    else
        @current_player = @player2
    end

    puts "\nGame loaded from #{file_name}"
    end


    def display_files
        files = Dir.glob('/home/juroga/Code/top_projects/Ruby/chess/saved_games/*') # This assumes all the game files have a .yaml extension
        if files.empty?
          puts "No game files found."
          return
        end
    
        selected_file = @prompt.select("Choose a file to load:", files)
        load_game(selected_file)
    end

end
