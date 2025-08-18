# frozen_string_literal: true

module TicTacToe
  module Board
    def self.generate_board
      Array.new(9, "-")
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
