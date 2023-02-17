# frozen_string_literal: true

require './lib/board'

describe Board do
    describe "set_up_pieces" do
        subject(:new_board) { described_class.new }

        context "When the board is initialize it place the white king in position" do
            it "returns 'king' when accesing position @board[0][4].type" do
                new_board.set_up_pieces
                expect(new_board.board[0][4].type).to eq("king")
            end
        end

    end
end