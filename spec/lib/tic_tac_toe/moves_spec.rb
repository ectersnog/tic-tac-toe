# frozen_string_literal: true

require "spec_helper"
require_relative "../../../lib/tic_tac_toe/game_info"
require_relative "../../../lib/tic_tac_toe/moves"

RSpec.describe TicTacToe::Moves do
  before do
    REDIS.flushdb
  end

  describe "player move" do
    context "when position is out of range" do
      it "rejects positions greater than 9" do
        game = create_game

        expect do
          game.player_move(position: 10, idempotency_key: "move-1")
        end.to raise_error(TicTacToe::InvalidMove, "Invalid position")
      end

      it "rejects negative positions" do
        game = create_game

        expect do
          game.player_move(position: -1, idempotency_key: "move-1")
        end.to raise_error(TicTacToe::InvalidMove, "Invalid position")
      end
    end

    context "when square is already taken" do
      it "returns 'Square already taken'" do
        game = create_game

        game.player_move(position: 2, idempotency_key: "move-1")

        expect do
          game.player_move(position: 2, idempotency_key: "move-2")
        end.to raise_error(TicTacToe::InvalidMove, "Square already taken")
      end
    end

    context "when using the same idempotency key" do
      it "returns the same response" do
        game = create_game

        first_request = game.player_move(position: 2, idempotency_key: "move-1")
        second_request = game.player_move(position: 2, idempotency_key: "move-1")

        expect(first_request).to eq(second_request)
      end

      it "returns the same response with a different position value" do
        game = create_game

        first_request = game.player_move(position: 2, idempotency_key: "move-1")
        second_request = game.player_move(position: 3, idempotency_key: "move-1")

        expect(first_request).to eq(second_request)
      end
    end
  end

  describe "when the computer plays a move" do
    it "returns a computer move" do
      game = create_game
      game.computer_move(idempotency_key: "move-1")
      computer_moves = game.board.board.count { |cell| cell == game.computer.marker }

      expect(computer_moves).to be 1
    end

    it "chooses the computer winning move" do
      game = create_winning_game([1, 2])
      game.computer_move(idempotency_key: "move-1")

      expect(game.computer.last_move).to eq(0)
    end
  end
end
