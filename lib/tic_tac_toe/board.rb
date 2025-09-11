# frozen_string_literal: true

module TicTacToe
  class Board
    attr_reader :board, :board_view

    def initialize(board = nil)
      @board = board || Array.new(9, '-')
      @board_view = self.class.generate_board_view(@board)
    end

    def board=(input)
      @board = input
      @board_view = self.class.generate_board_view(@board)
    end

    def self.generate_board_view(board)
      board_view = []
      board.each_slice(3) do |row|
        board_view << row
      end
      board_view
    end
  end
end
