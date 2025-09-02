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
        move_request = TicTacToe::MoveRequest.new(
          id: game.id,
          position: 10,
          idempotency_key: "move-1"
        )
        expect do
          described_class.player_move(move_request:, token: game.token)
        end.to raise_error(TicTacToe::InvalidMove, "Invalid position")
      end

      it "rejects negative positions" do
        game = create_game
        move_request = TicTacToe::MoveRequest.new(
          id: game.id,
          position: -1,
          idempotency_key: "move-1"
        )
        expect do
          described_class.player_move(move_request:, token: game.token)
        end.to raise_error(TicTacToe::InvalidMove, "Invalid position")
      end
    end

    context "when square is already taken" do
      it "returns 'Square already taken'" do
        game = create_game
        first_request = TicTacToe::MoveRequest.new(
          id: game.id,
          position: 2,
          idempotency_key: "move-1"
        )
        described_class.player_move(move_request: first_request, token: game.token)

        second_request = TicTacToe::MoveRequest.new(
          id: game.id,
          position: 2,
          idempotency_key: "move-2"
        )
        expect do
          described_class.player_move(move_request: second_request, token: game.token)
        end.to raise_error(TicTacToe::InvalidMove, "Square already taken")
      end
    end

    context "when using the same idempotency key" do
      it "returns the same response" do
        game = create_game
        request = TicTacToe::MoveRequest.new(
          id: game.id,
          position: 2,
          idempotency_key: "move-1"
        )
        first_request = described_class.player_move(
          move_request: request,
          token: game.token
        )

        second_request = described_class.player_move(
          move_request: request,
          token: game.token
        )

        expect(first_request).to eq(second_request)
      end

      it "returns the same response with a different position value" do
        game = create_game
        request1 = TicTacToe::MoveRequest.new(
          id: game.id,
          position: 2,
          idempotency_key: "move-1"
        )

        request2 = TicTacToe::MoveRequest.new(
          id: game.id,
          position: 3,
          idempotency_key: "move-1"
        )

        first_request = described_class.player_move(
          move_request: request1,
          token: game.token
        )

        second_request = described_class.player_move(
          move_request: request2,
          token: game.token
        )

        expect(first_request).to eq(second_request)
      end
    end
  end

  describe "when the computer plays a move" do
    it "returns a computer move" do
      game = create_game
      move_request = TicTacToe::MoveRequest.new(
        id: game.id,
        position: 2,
        idempotency_key: "move-1"
      )

      computer_moves = described_class.computer_move(
        move_request:,
        token: game.token
      ).board.count { |cell| cell == game.computer }

      expect(computer_moves).to be 1
    end

    it "chooses the computer winning move" do
      game = create_winning_game([1, 2], symbol: 'O')
      move_request = TicTacToe::MoveRequest.new(
        id: game.id,
        position: 7,
        idempotency_key: "move-1"
      )

      computer_move = described_class.computer_move(
        move_request:,
        token: game.token
      )

      expect(computer_move.last_move_computer).to eq(1)
    end
  end
end
