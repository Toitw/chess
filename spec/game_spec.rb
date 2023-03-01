# frozen_string_literal: true

require './lib/game'

describe Game do
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

        it "Raise an error when there is no piece on the selected origin" do
          allow_any_instance_of(Kernel).to receive(:gets).and_return("test")
          new_game_origin.player1.color = "white"
          new_game_origin.player2.color = "black"
          new_game_origin.current_player.origin = [0, 3]
          expect { new_game_origin.check_origin }.to output("There is no piece on that coordinate, please choose another one\n").to_stdout
        end
    end
=begin
        it "selected_piece equals a pice type = rook and color = white when origin is equal to [1,1] " do
            new_game_origin.player1.color = "White"
            new_game_origin.player2.color = "Black"
            new_game_origin.current_player.origin = [1, 1]
            new_game_origin.check_origin
            expect(new_game_origin.selected_piece.type).to eq(:pawn)
            expect(new_game_origin.selected_piece.color).to eq(:white)
        end

        it "Returns a meesage of incorrect piece" do
            new_game_origin.player1.color = "White"
            new_game_origin.player2.color = "Black"
            new_game_origin.current_player.origin = [0, 7]
            new_game_origin.check_origin
            expect { new_game_origin.check_origin }.to output("That is not your piece! Please, choose one of your pieces to move\n").to_stdout
        end
    end

    describe "get_all_moves" do
        subject(:new_game_all_moves) { described_class.new }

        before do
            new_game_origin.instance_variable_set(:@board, Board.new)
        end

        context "When a knight on square [1,0] is selected"
        it "Returns moves with values [[0, 2], [2, 2], [3,1]]" do
            new_game_all_moves.selected_piece.type = :knight
            new_game_all_moves.current_player.origin = [1,0]
            expect(get_all_moves(@selected_piece.type, @current_player.origin)).to eq([[0, 2], [2, 2], [3,1]])
        end
    end
=end

end
  
