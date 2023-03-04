# frozen_string_literal: true

require './lib/game'

describe Game do
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

        context "When a knight on square [1,0] is selected"
        xit "Returns moves with values [[0, 2], [2, 2], [3,1]]" do
            expect(game.get_all_moves(game.selected_piece.type, game.current_player.origin)).to eq([[0, 2], [2, 2], [3,1]])
        end

        before do
            game.instance_variable_set(:@selected_piece, Piece.new(:bishop, :white))
            game.current_player.origin = [3,3]
        end
        
        context "when a bishop on square [3,3] is selected" do
            it "returns moves with values [[4,4],[5,5],[6,6],[7,7],[4,2],[5,1],[6,0],[2,4],[1,5],[0,6],[2,2],[1,1],[0,0]]" do
              expect(game.get_all_moves(game.selected_piece.type, game.current_player.origin)).to eq([[4,4],[5,5],[6,6],[7,7],[4,2],[5,1],[6,0],[2,2],[1,1],[0,0],[2,4],[1,5],[0,6]])
            end
        end

        context "when a rook is selected" do
            before do
              game.instance_variable_set(:@selected_piece, Piece.new(:rook, :white))
            end
        
            it "returns all possible moves for the rook" do
              game.current_player.origin = [3, 3]
              expected_moves = [[3, 0], [3, 1], [3, 2], [3, 4], [3, 5], [3, 6], [3, 7], [0, 3], [1, 3], [2, 3], [4, 3], [5, 3], [6, 3], [7, 3]]
              expect(game.get_all_moves(game.selected_piece.type, game.current_player.origin)).to match_array(expected_moves)
            end
        end

        context "when a queen is selected" do
            before do
              game.instance_variable_set(:@selected_piece, Piece.new(:queen, :white))
            end
        
            it "returns all possible moves for the queen" do
              game.current_player.origin = [3, 3]
              expected_moves = [[3, 0], [3, 1], [3, 2], [3, 4], [3, 5], [3, 6], [3, 7], [0, 3], [1, 3], [2, 3], [4, 3], [5, 3], [6, 3], [7, 3], [0, 0], [1, 1], [2, 2], [4, 4], [5, 5], [6, 6], [7, 7], [2, 4], [1, 5], [0, 6], [4, 2], [5, 1], [6, 0]]
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
        it "raises an error and retries" do
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
        
              it "moves the knight to [2, 2] on the board" do
                game.move_selected_piece
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
          
                it "moves the knight to [2, 2] on the board" do
                  game.move_selected_piece
                  expect(game.instance_variable_get(:@board).board[1][0]).to eq(nil)
                  expect(game.instance_variable_get(:@board).board[2][2]).to eq(game.instance_variable_get(:@selected_piece))
                end
            end

        end

    end

end
  
