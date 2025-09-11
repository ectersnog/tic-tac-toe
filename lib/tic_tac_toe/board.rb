# frozen_string_literal: true

module TicTacToe
  class Board
    attr_reader :board, :board_view

    def initialize(board = nil)
      self.board = board || Array.new(9, '-')
    end

    def board=(input)
      @board = input
      @board_view = self.class.generate_board_view(@board)
    end

    def play_square(position, player)
      new_board = @board.dup
      new_board[position] = player
      self.board = new_board
    end

    def square_free?(position)
      @board[position] == "-"
    end

    def self.generate_board_view(board)
      board.each_slice(3).to_a
    end
  end
end
