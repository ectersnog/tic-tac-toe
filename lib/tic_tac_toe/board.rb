# frozen_string_literal: true

module TicTacToe
  class Board
    # Represents a Tic Tac Toe board
    attr_reader :board, :board_view

    # Create a new board
    #
    # @param board [Array<String>] An optional array containing "X", "O", or "-"
    # @return [TicTacToe::Board]
    def initialize(board = nil)
      @board = board || Array.new(9, '-')
      @board_view = generate_board_view(@board)
    end

    # Set the board to input and update board_view
    def board=(input)
      @board = input
      @board_view = generate_board_view(@board)
    end

    # Method to set a board position to a player marker
    #
    # @param position [Integer] The position to be changed
    # @param player [TicTacToe::Player] The player to set the position to
    def play_square(position, player)
      @board[position] = player.marker
      @board_view = generate_board_view(@board)
    end

    # Check if board position is already taken
    # @param position [Integer] The position in the board to check
    # @return [Boolean] True or False
    def square_free?(position)
      @board[position] == "-"
    end

    # Check the available positions playable
    #
    # @return [Array] The position still left that can be played
    def available_positions
      @board.each_index.select { |i| square_free?(i) }
    end

    # Returns the board_view from board
    #
    # @param board [Array<String>] The board to be returned as board_view
    # @return [Array<Array<String>>] Board sliced into a 3x3 array of values
    def generate_board_view(board)
      board.each_slice(3).to_a
    end

    # Return the board array as json for saving
    def board_json
      JSON.dump(@board)
    end

    # Return the board_view array as json for saving
    def board_view_json
      JSON.dump(@board_view)
    end
  end
end
