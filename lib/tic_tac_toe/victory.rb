# frozen_string_literal: true

module TicTacToe
  module Victory
    WINNING_COMBINATIONS = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6]
    ].freeze
    def self.check_winner(game, player)
      WINNING_COMBINATIONS.any? do |positions|
        positions.all? { |cell| game.board[cell] == player }
      end
    end

    def self.check_boxes(game, player, pos1, pos2, pos3)
      [pos1, pos2, pos3].all? { |i| game.board[i] == player }
    end

    def self.game_won?(game)
      game.status == "completed"
    end
  end
end
