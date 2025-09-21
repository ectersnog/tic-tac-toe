# frozen_string_literal: true

module TicTacToe
  class Board
    attr_reader :board, :board_view

    def initialize(board = nil)
      @board = board || Array.new(9, '-')
      @board_view = generate_board_view(@board)
    end

    def board=(input)
      @board = input
      @board_view = generate_board_view(@board)
    end

    def play_square(position, player)
      @board[position] = player.marker
      @board_view = generate_board_view(@board)
    end

    def square_free?(position)
      @board[position] == "-"
    end

    def available_positions
      @board.each_index.select { |i| square_free?(i) }
    end

    def generate_board_view(board)
      board.each_slice(3).to_a
    end

    def board_json
      JSON.dump(@board)
    end

    def board_view_json
      JSON.dump(@board_view)
    end
  end
end
