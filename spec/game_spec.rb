# frozen_string_literal: true

require './lib/game'
require 'fileutils'
require_relative '/home/juroga/Code/top_projects/Ruby/chess/lib/chessInitialPositions'

describe Game do
  include ChessInitialPositions
    subject(:game) { described_class.new }
    describe "check_color" do
      subject(:new_game) { described_class.new }
  
      it "returns an error when color input is different from W or B" do
        allow(new_game).to receive(:gets).and_return("T", "w")
        new_game.instance_variable_set(:@current_player, Player.new("test_player"))
        expect { new_game.check_color }.to output("Please, write only 'B' for blacks or 'W' for whites\n").to_stdout
        expect(new_game.instance_variable_get(:@current_player).color).to eq("white")
      end
    end

    describe "change_current_player" do
        subject(:new_game) { described_class.new }
            it "Change @current_player to @player2 when @current_player is @player1" do
                expect(new_game.current_player.name).to eq("Player1")
                new_game.change_current_player
                expect(new_game.current_player.name).to eq("Player2")
            end
    end

    describe "check_origin" do
        subject(:new_game_origin) { described_class.new }

        xit "Raise an error when there is no piece on the selected origin" do
          allow_any_instance_of(Kernel).to receive(:gets).and_return("test")
          new_game_origin.player1.color = "white"
          new_game_origin.player2.color = "black"
          new_game_origin.current_player.origin = [0, 3]
          expect { new_game_origin.check_origin }.to output("There is no piece on that coordinate, please choose another one\n").to_stdout
        end

        it "selected_piece equals a pice type = rook and color = white when origin is equal to [1,1] " do
            new_game_origin.player1.color = "white"
            new_game_origin.player2.color = "black"
            new_game_origin.current_player.origin = [1, 1]
            new_game_origin.check_origin
            expect(new_game_origin.selected_piece.type).to eq(:pawn)
            expect(new_game_origin.selected_piece.color).to eq(:white)
        end

        xit "Returns a meesage of incorrect piece" do
            new_game_origin.player1.color = "white"
            new_game_origin.player2.color = "black"
            new_game_origin.current_player.origin = [0, 7]
            new_game_origin.check_origin
            expect { new_game_origin.check_origin }.to output("That is not your piece! Please, choose one of your pieces to move\n").to_stdout
        end
    end

    describe "get_all_moves" do

        before do
            game.instance_variable_set(:@board, Board.new)
            game.instance_variable_set(:@current_player, Player.new("John", :white))
            game.instance_variable_set(:@selected_piece, Piece.new(:knight, :white))
            game.current_player.origin = [1,0]
        end

        context "When a knight on square [1,0] is selected at initial positions"
        xit "Returns moves with values [[0, 2], [2, 2], [3,1]]" do
            expect(game.get_all_moves(game.selected_piece.type, game.current_player.origin)).to eq([[0, 2], [2, 2], [3,1]])
        end

        before do
            game.instance_variable_set(:@selected_piece, Piece.new(:bishop, :white))
            game.current_player.origin = [3,3]
        end
        
        context "when a bishop on square [3,3] is selected at initial positions" do
            it "returns moves with all posible moves" do
              expected_moves = [[4, 4], [5, 5], [4, 2], [2, 2], [2, 4], [1, 5], [6, 6], [0, 6]]
              expect(game.get_all_moves(game.selected_piece.type, game.current_player.origin)).to match_array(expected_moves)
            end
        end

        context "when a bishop on square [0, 2] is selected at initial positions" do
          it "returns moves with all posible moves" do
            game.current_player.origin = [0, 2]
            expected_moves = [[1, 3], [2, 4], [3, 5], [4, 6]]
            expect(game.get_all_moves(game.selected_piece.type, game.current_player.origin)).to match_array(expected_moves)
          end
        end

        context "when a bishop on square [5, 0] is selected at initial positions" do
          it "returns moves with all posible moves" do
            game.current_player.origin = [5, 0]
            expected_moves = []
            expect(game.get_all_moves(game.selected_piece.type, game.current_player.origin)).to match_array(expected_moves)
          end
        end

        context "when a bishop on square [5, 2] is selected at initial positions" do
          it "returns moves with all posible moves" do
            game.current_player.origin = [5, 2]
            expected_moves = [[6,3], [7,4], [1, 6], [2, 5], [3, 4], [4, 3]]
            expect(game.get_all_moves(game.selected_piece.type, game.current_player.origin)).to match_array(expected_moves)
          end
        end

        context "when a rook is selected at initial positions" do
            before do
              game.instance_variable_set(:@selected_piece, Piece.new(:rook, :white))
            end
        
            it "returns all possible moves for the rook in position [3,3]" do
              game.current_player.origin = [3, 3]
              expected_moves = [[0, 3], [1, 3], [2, 3], [3, 2], [3, 4], [3, 5], [4, 3], [5, 3], [6, 3], [7, 3], [3, 6]]
              expect(game.get_all_moves(game.selected_piece.type, game.current_player.origin)).to match_array(expected_moves)
            end

            it "returns all possible moves for the rook in position [7,0]" do
              game.current_player.origin = [7, 0]
              expected_moves = []
              expect(game.get_all_moves(game.selected_piece.type, game.current_player.origin)).to match_array(expected_moves)
            end
        end

        context "when a queen is selected at initial positions" do
            before do
              game.instance_variable_set(:@selected_piece, Piece.new(:queen, :white))
            end
        
            it "returns all possible moves for the queen in position [3,3]" do
              game.current_player.origin = [3, 3]
              expected_moves = [[4, 4], [5, 5], [4, 2], [2, 2], [2, 4], [1, 5], [0, 3], [1, 3], [2, 3], [3, 2], [3, 4], [3, 5], [4, 3], [5, 3], [6, 3], [7, 3], [3, 6],  [6, 6], [0, 6]]
              expect(game.get_all_moves(game.selected_piece.type, game.current_player.origin)).to match_array(expected_moves)
            end

            it "returns all possible moves for the queen in position [3,0]" do
              game.current_player.origin = [3, 0]
              expected_moves = []
              expect(game.get_all_moves(game.selected_piece.type, game.current_player.origin)).to match_array(expected_moves)
            end
        end

        context "when a king is selected" do
            before do
              game.instance_variable_set(:@selected_piece, Piece.new(:king, :white))
            end
        
            it "returns all possible moves for the king" do
              game.current_player.origin = [4, 4]
              expected_moves = [[3, 4], [3, 3], [3, 5], [4, 3], [4, 5], [5, 3], [5, 4], [5, 5]]
              expect(game.get_all_moves(game.selected_piece.type, game.current_player.origin)).to match_array(expected_moves)
            end
        end

        context "when a white pawn is selected" do
            before do
              game.instance_variable_set(:@selected_piece, Piece.new(:pawn, :white))
            end
        
            it "returns all possible moves for a white pawn in [0, 1]" do
              game.current_player.origin = [0, 1]
              expected_moves = [[0,2],[0,3]]
              puts "Expected moves: #{expected_moves.inspect}"
              expect(game.get_all_moves(game.selected_piece.type, game.current_player.origin)).to eq([[0,2],[0,3]])
            end

            it "returns all possible moves for a white pawn in [1, 2] when oponent pieces are in [0 ,3] and [2, 3]" do
              game.current_player.origin = [1, 2]
              game.board.board[0][3] = Piece.new(:pawn, :black)
              game.board.board[2][3] = Piece.new(:pawn, :black)
              expected_moves = [[1,3],[0,3],[2,3]]
              puts "Expected moves: #{expected_moves.inspect}"
              expect(game.get_all_moves(game.selected_piece.type, game.current_player.origin)).to match_array(expected_moves)
            end
        end

        context "when a black pawn is selected" do
            before do
              game.instance_variable_set(:@selected_piece, Piece.new(:pawn, :black))
            end
        
            it "returns all possible moves for a black pawn in [0, 6]" do
              game.current_player.origin = [0, 6]
              expected_moves = [[0,5],[0,4]]
              expect(game.get_all_moves(game.selected_piece.type, game.current_player.origin)).to eq([[0,5],[0,4]])
            end

            before do
                game.instance_variable_set(:@selected_piece, Piece.new(:pawn, :black))
            end

            it "returns all possible moves for a black pawn in [0, 6] with a piece in [0, 5]" do
                game.current_player.origin = [0, 6]
                game.board.board[0][5] = Piece.new(:knight, :white)
                expected_moves = [[0, 5]]
                expect(game.get_all_moves(game.selected_piece.type, game.current_player.origin)).to match_array(expected_moves)
            end
        end
    end

    describe "get_available_moves" do

        before do
            game.instance_variable_set(:@selected_piece, Piece.new(:knight, :white))
            game.instance_variable_set(:@current_player, Player.new("test",:white))
        end

        context "When a knight on square [1,0] is selected"
        xit "Returns moves with values [[0, 2], [2, 2]]" do
            all_moves = [[0, 2], [2, 2], [3,1]]
            expect(game.get_available_moves(game.selected_piece.type, all_moves)).to eq([[0, 2], [2, 2]])
        end

        context "When a knight on square g7 [6, 0] is selected"
        xit "Returns moves with values [[5, 2], [7, 2]]" do
            all_moves = [[5, 2], [7, 2], [4, 1]]
            expect(game.get_available_moves(game.selected_piece.type, all_moves)).to eq([[5, 2], [7, 2]])
        end
    end

    describe "choose_destination" do
        subject(:game) { described_class.new }

        before do
            allow(game).to receive(:gets).and_return("33", "e4")
        end
      
        xit "raises an error and retries" do
            expect { game.choose_destination }.to output(/Invalid input/).to_stdout
            expect { game.choose_destination }.not_to raise_error
        end

        before do
            allow(game).to receive(:gets).and_return("d2", "c3")
            game.instance_variable_set(:@selected_piece, Piece.new(:knight, :white))
            game.instance_variable_set(:@current_player, Player.new("test",:white))
            game.instance_variable_set(:@available_moves, [[0, 2], [2, 2]])
        end

        context "Current player inputs a move that is not available"
        xit "raises an error and retries" do
            expect { game.choose_destination }.to output(/Invalid move/).to_stdout
            expect { game.choose_destination }.not_to raise_error
        end
    end

    describe "move_selected_piece" do
        # Set up the board with a white knight on [1, 0]
        before do
            game.instance_variable_set(:@board, Board.new)
            game.instance_variable_set(:@selected_piece, Piece.new(:knight, :white))
            game.instance_variable_set(:@current_player, Player.new("White", :white))
            game.instance_variable_get(:@board).board[1][0] = game.instance_variable_get(:@selected_piece)
        end

        describe "#move_selected_piece" do
            context "when moving the selected knight to [2, 2]" do
              before do
                game.instance_variable_get(:@current_player).destination = [2, 2]
                game.instance_variable_get(:@current_player).origin = [1, 0]
              end
        
              xit "moves the knight to [2, 2] on the board" do
                game.move_selected_piece(:@board)
                expect(game.instance_variable_get(:@board).board[1][0]).to eq(nil)
                expect(game.instance_variable_get(:@board).board[2][2]).to eq(game.instance_variable_get(:@selected_piece))
              end
            end

            context "when moving the selected knight to [2, 2] and it eats a piece" do
                before do
                  game.instance_variable_get(:@current_player).destination = [2, 2]
                  game.instance_variable_get(:@current_player).origin = [1, 0]
                  game.instance_variable_get(:@board).board[2][2] = Piece.new(:knight, :black)
                end
          
                xit "moves the knight to [2, 2] on the board" do
                  game.move_selected_piece
                  expect(game.instance_variable_get(:@board).board[1][0]).to eq(nil)
                  expect(game.instance_variable_get(:@board).board[2][2]).to eq(game.instance_variable_get(:@selected_piece))
                end
            end

        end

    end

    describe "king_position" do

      before do
        game.instance_variable_set(:@current_player, Player.new("Player1", :white))
      end

      it "returns an array with the coordinates of the current_player's king position" do
        expect(game.king_position).to eq([4, 0])
      end
    end

    
    describe "in_check?" do
      before do
        game.instance_variable_set(:@current_player, Player.new("Player1", :white))
      end

      # Test for check_knight_attacks
      context 'when the king is in check by a knight' do
        it 'returns true' do
          game.board.board[6][3] = Piece.new(:knight, :black) # Place a black knight on the board
          king_position = [4, 4]
          expect(game.check_knight_attacks(king_position)).to be true
        end
      end

      # Test for check_pawn_attacks
      context 'when the king is in check by a pawn' do
        it 'returns true' do
          game.board.board[3][5] = Piece.new(:pawn, :black) # Place a black pawn on the board
          king_position = [4, 4]
          expect(game.check_pawn_attacks(king_position)).to be true
        end
      end

      # Test for check_vertical_lateral_attacks
      context 'when the king is in check by a rook' do
        it 'returns true' do
          game.board.board[4][0] = Piece.new(:rook, :black) # Place a black rook on the board
          game.board.board[4][1] = nil #Remove the pawn
          king_position = [4, 4]
          expect(game.check_vertical_lateral_attacks(king_position)).to be true
        end
      end

      # Test for check_diagonal_attacks
      context 'when the king is in check by a bishop' do
        it 'returns true' do
          game.board.board[3][5] = Piece.new(:bishop, :black) # Place a black bishop on the board
          king_position = [4, 4]
          expect(game.check_diagonal_attacks(king_position)).to be true
        end
      end

      # Test for check_king_attacks
      context 'when the king is in check by another king' do
        it 'returns true' do
          game.board.board[4][3] = Piece.new(:king, :black) # Place a black king on the board
          king_position = [4, 4]
          expect(game.check_king_attacks(king_position)).to be true
        end
      end


      context 'when there is a diagonal attack' do
        it 'returns true' do
          game.board.board[3][5] = Piece.new(:bishop, :black) # Replace with your method to set a piece on the board
          king_position = [4, 4]
          expect(game.check_diagonal_attacks(king_position)).to be true
        end
      end

      context 'when there is a diagonal attack by a queen' do
        it 'returns true' do
          game.board.board[2][6] = Piece.new(:queen, :black) # Place a black queen on the board
          king_position = [4, 4]
          expect(game.check_diagonal_attacks(king_position)).to be true
        end
      end
      
      context 'when there is no attack because the attacking piece is the same color' do
        it 'returns false' do
          game.board.board[3][5] = Piece.new(:bishop, :white) # Place a white bishop on the board
          king_position = [4, 4]
          expect(game.check_diagonal_attacks(king_position)).to be false
        end
      end

      context 'when there is a king attack' do
        it 'returns true' do
          game.board.board[4][3] = Piece.new(:king, :black) # Place a black king on the board
          king_position = [4, 4]
          expect(game.check_king_attacks(king_position)).to be true
        end
      end
      
      context 'when there is no king attack due to distance' do
        it 'returns false' do
          game.board.board[4][2] = Piece.new(:king, :black) # Place a black king on the board
          king_position = [4, 4]
          expect(game.check_king_attacks(king_position)).to be false
        end
      end     
      
      context 'when the black king moves to [3, 4]' do
        it 'is not in check' do
          game.board.board[4][5] = Piece.new(:king, :black) # Place a black king on the board
          game.board.board[4][4] = Piece.new(:pawn, :white) # Place a white pawn on the board
          game.board.board[7][4] = Piece.new(:queen, :white) # Place a white queen on the board
      
          # Move the black king to the position [3, 4]
          game.board.board[3][4] = game.board.board[4][5]
          game.board.board[4][5] = nil
      
          king_position = [3, 4]
          game.current_player.color.to_sym == :black
          expect(game.in_check?(king_position)).to be false
        end
      end
      
      
    end

    describe '#find_pieces_by_color' do
      context 'when the color is white' do
        let(:white_pieces) { described_class.new.find_pieces_by_color(:white) }
  
        it 'returns the correct number of white pieces' do
          expect(white_pieces.count).to eq(16) # Assuming a standard chess setup
        end
  
        it 'returns white pawns with correct coordinates' do
          white_pawns = white_pieces.select { |piece| piece[:type] == :pawn }
          white_pawn_coordinates = white_pawns.map { |pawn| pawn[:coordinates] }
          expect(white_pawn_coordinates).to match_array(ChessInitialPositions::INITIAL_POSITIONS[:pawn][:white])
        end
  
        # Add more tests for other white piece types as needed
      end
  
      context 'when the color is black' do
        let(:black_pieces) { described_class.new.find_pieces_by_color(:black) }
  
        it 'returns the correct number of black pieces' do
          expect(black_pieces.count).to eq(16) # Assuming a standard chess setup
        end
  
        it 'returns black pawns with correct coordinates' do
          black_pawns = black_pieces.select { |piece| piece[:type] == :pawn }
          black_pawn_coordinates = black_pawns.map { |pawn| pawn[:coordinates] }
          expect(black_pawn_coordinates).to match_array(ChessInitialPositions::INITIAL_POSITIONS[:pawn][:black])
        end
  
      end
    end

    describe '#checkmate?' do
      context 'when the player has legal moves' do

        before do
          game.instance_variable_set(:@current_player, Player.new("Player1", :white))
        end

        it 'returns false' do
          # Assuming a standard chess setup
          expect(game.checkmate?(:white)).to be false
          expect(game.checkmate?(:black)).to be false
        end
      end
  
      context 'when the player is in check and has no legal moves' do
        before do
          # Set up a custom board configuration that leads to no legal moves for one player
          # Example: A simple stalemate position (Note that this example does not cover all possible cases)
          game.instance_variable_set(:@selected_piece, nil)
          game.instance_variable_set(:@current_player, Player.new("Player2", :black))
  
          game.board.board[0][0] = Piece.new(:king, :black)
          game.board.board[2][0] = nil
          game.board.board[1][0] = nil
          game.board.board[3][1] = nil
          game.board.board[1][1] = Piece.new(:queen, :white)
          game.board.board[2][2] = Piece.new(:king, :white)
        end
  
        it 'returns true' do
          expect(game.checkmate?(:black)).to be true
        end
      end
    end

    describe '#only_kings?' do
      it 'returns true when there are only kings' do
        white_pieces = [{ type: :king, coordinates: [4, 0] }]
        black_pieces = [{ type: :king, coordinates: [4, 7] }]
        expect(game.only_kings?(white_pieces, black_pieces)).to be true
      end
  
      it 'returns false when there are other pieces' do
        white_pieces = [{ type: :king, coordinates: [4, 0] }, { type: :bishop, coordinates: [2, 0] }]
        black_pieces = [{ type: :king, coordinates: [4, 7] }]
        expect(game.only_kings?(white_pieces, black_pieces)).to be false
      end
    end

    describe '#same_color_squares?' do
      it 'returns true when bishops are on the same color squares' do
        bishops = [{ type: :bishop, coordinates: [1, 1] }, { type: :bishop, coordinates: [3, 3] }]
        expect(game.same_color_squares?(bishops)).to be true
      end
  
      it 'returns false when bishops are on different color squares' do
        bishops = [{ type: :bishop, coordinates: [1, 1] }, { type: :bishop, coordinates: [2, 3] }]
        expect(game.same_color_squares?(bishops)).to be false
      end
    end

    describe '#insufficient_materials?' do
      it 'returns true when only kings are on the board' do
        allow(game).to receive(:only_kings?).and_return(true)
        expect(game.insufficient_materials?).to be true
      end
  
      it 'returns true when kings and bishops are on the board and bishops are on the same color squares' do
        allow(game).to receive(:only_kings?).and_return(false)
        allow(game).to receive(:king_and_bishops_only?).and_return(true)
        expect(game.insufficient_materials?).to be true
      end
  
      it 'returns false when other pieces are on the board' do
        allow(game).to receive(:only_kings?).and_return(false)
        allow(game).to receive(:king_and_bishops_only?).and_return(false)
        expect(game.insufficient_materials?).to be false
      end
    end

    describe '#king_and_bishops_only?' do
      it 'returns true when only kings and bishops are on the board, and all bishops are on the same color squares' do
        white_pieces = [
          { type: :king, coordinates: [4, 0] },
          { type: :bishop, coordinates: [2, 0] }
        ]
        black_pieces = [
          { type: :king, coordinates: [4, 7] },
          { type: :bishop, coordinates: [2, 7] }
        ]
        expect(game.king_and_bishops_only?(white_pieces, black_pieces)).to be true
      end
  
      it 'returns false when other pieces are on the board' do
        white_pieces = [
          { type: :king, coordinates: [4, 0] },
          { type: :bishop, coordinates: [2, 0] },
          { type: :knight, coordinates: [1, 0] }
        ]
        black_pieces = [
          { type: :king, coordinates: [4, 7] },
          { type: :bishop, coordinates: [2, 7] }
        ]
        expect(game.king_and_bishops_only?(white_pieces, black_pieces)).to be false
      end
    end

    describe '#exit_game' do
      it 'prints the farewell message and exits the program' do
        expect(game).to receive(:puts).with("Thanks for playing! Goodbye!")
        expect(game).to receive(:exit)
        game.exit_game
      end
    end

end
  
