# frozen_string_literal: true

require 'spec_helper'
require_relative "../../../lib/tic_tac_toe/board"

RSpec.describe TicTacToe::Board do
  it "generates a board" do
    board = described_class.generate_board
    expect(board).to be_an(Array)
    empty_board = board.count { |cell| cell == '-' }
    expect(empty_board).to be 9
  end

  it "generates a board view from a board" do
    board = described_class.generate_board
    board_view = described_class.generate_board_view(board)
    expect(board_view).to be_an(Array)
    expect(board_view.count).to be 3
    empty_board = board_view
      .compact
      .flatten
      .count { |cell| cell == '-' }
    expect(empty_board).to be 9
  end
end
