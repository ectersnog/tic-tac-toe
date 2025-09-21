# frozen_string_literal: true

module TicTacToe
  class Player
    attr_accessor :marker, :last_move

    def initialize(marker:, last_move:)
      @marker = marker
      @last_move = last_move
    end
  end
end