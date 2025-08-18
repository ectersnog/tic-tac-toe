# frozen_string_literal: true

module TicTacToe
  module Victory
    def self.check_winner(game, player)
      check_boxes(game, player, 0, 1, 2) ||
        check_boxes(game, player, 3, 4, 5) ||
        check_boxes(game, player, 6, 7, 8) ||
        check_boxes(game, player, 0, 3, 6) ||
        check_boxes(game, player, 1, 4, 7) ||
        check_boxes(game, player, 2, 5, 8) ||
        check_boxes(game, player, 0, 4, 8) ||
        check_boxes(game, player, 2, 4, 6)
    end

    def self.check_boxes(game, player, pos1, pos2, pos3)
      [pos1, pos2, pos3].all? { |i| game.board[i] == player }
    end

    def self.game_won?(game)
      game.status == "completed"
    end
  end
end
