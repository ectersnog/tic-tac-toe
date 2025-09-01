# frozen_string_literal: true

module TicTacToe
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

  MoveRequest = Data.define(
    :id,
    :position,
    :idempotency_key
  )
end
