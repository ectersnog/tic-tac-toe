# frozen_string_literal: true

module TicTacToe
  class GameNotFound < StandardError; end
  class InvalidToken < StandardError; end
  class InvalidMove < StandardError; end

  # Data structure for passing Game information between methods

  GameInfo = Data.define(
    :id,
    :board,
    :board_view,
    :turn,
    :player,
    :computer,
    :status,
    :winner,
    :last_move_player,
    :last_move_computer,
    :token
  )

  # Data structure for passing Move information between methods
  MoveRequest = Data.define(
    :id,
    :position,
    :idempotency_key
  )
end
