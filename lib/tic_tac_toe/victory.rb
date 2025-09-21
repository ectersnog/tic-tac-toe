# frozen_string_literal: true

module TicTacToe
  module Victory
    # Methods for checking for victory states
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

    # Checks a board to see if a player has won
    #
    # @param board [TicTacToe::Board] The current game board
    # @param player [TicTacToe::Player] The player to be checked for victory
    # @return [Boolean] True or False Win or not
    def self.check_winner(board, player)
      WINNING_COMBINATIONS.any? do |positions|
        positions.all? { |cell| board[cell] == player }
      end
    end

    # Simple helper method for checking certain positions for player marker
    #
    # @param game [TicTacToe::Game] The current game
    # @param player [String] The player marker to check
    # @param pos1 [Integer] position 1 to check
    # @param pos2 [Integer] position 2 to check
    # @param pos3 [Integer] position 3 to check
    # @return [Boolean] True if all match player False if they don't

    def self.check_boxes(game, player, pos1, pos2, pos3)
      [pos1, pos2, pos3].all? { |i| game.board[i] == player }
    end

    # Method for checking if game is won
    #
    # @param game [TicTacToe::Game] Game object to check
    # @return [Boolean] True if completed False if not
    def self.game_won?(game)
      game.status == "completed"
    end
  end
end
