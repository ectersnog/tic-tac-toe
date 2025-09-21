# frozen_string_literal: true

module TicTacToe
  class Player
    # Class to keep information related to player objects
    #
    # @param marker [String] "X" or "O" The marker to use for player object
    # @param last_move [Integer] The last position played by player
    attr_accessor :marker, :last_move

    def initialize(marker:, last_move:)
      @marker = marker
      @last_move = last_move
    end
  end
end
