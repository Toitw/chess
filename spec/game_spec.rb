# frozen_string_literal: true

require './lib/board'
require './lib/game'
=begin
describe Board do
    describe "set_up_pieces" do
        subject(:new_board) { described_class.new }

        context "When the board is initialize it place the white king in position" do
            it "returns 'king' when accesing position @board[0][4].type" do
                new_board.set_up_pieces
                expect(new_board.board[0][4].type).to eq(:king)
            end
        end

    end
end
=end

describe Game do
    describe "check_color" do
      subject(:new_game) { described_class.new }
  
      it "returns an error when color input is different from W or B" do
        allow(new_game).to receive(:gets).and_return("T", "w")
        new_game.instance_variable_set(:@current_player, Player.new("test_player"))
        expect { new_game.check_color }.to output("Please, write only 'B' for blacks or 'W' for whites\n").to_stdout
        expect(new_game.instance_variable_get(:@current_player).color).to eq("White")
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
      

      
        before do
          new_game_origin.instance_variable_set(:@board, Board.new)
        end
      
        it "Raise an error when there is no piece on the selected origin" do
          new_game_origin.player1.color = "White"
          new_game_origin.player2.color = "Black"
          new_game_origin.current_player.origin = [0, 3]
          expect {new_game_origin.check_origin }.to output("There is no piece on that coordinate, please choose another one\n").to_stdout
        end

        it "selected_piece equals a pice type = rook and color = white when origin is equal to [1,1] " do
            new_game_origin.player1.color = "White"
            new_game_origin.player2.color = "Black"
            new_game_origin.current_player.origin = [1, 1]
            new_game_origin.check_origin
            expect(new_game_origin.selected_piece.type).to eq(:pawn)
            expect(new_game_origin.selected_piece.color).to eq(:white)
        end
    end


end
  
