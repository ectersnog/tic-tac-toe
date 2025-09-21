# frozen_string_literal: true

require 'tic_tac_toe/game_info'

class GamesController < ApplicationController
  rescue_from TicTacToe::GameNotFound, with: :game_not_found
  rescue_from TicTacToe::InvalidToken, with: :invalid_token
  rescue_from TicTacToe::InvalidMove, with: :invalid_move

  def index
    game_info = if params[:player]
      TicTacToe::Game.new(player: params[:player])
    else
      TicTacToe::Game.new
    end

    render locals: { game_info: }
  end

  def show
    token = request.headers["X-Game-Token"]

    game_info = TicTacToe::Game.new(
      id: params[:id],
      player: params[:player],
      token:
    )
    render locals: { game_info: }
  end

  def update
    idempotency_key = check_idempotency_key
    token = request.headers["X-Game-Token"]
    if idempotency_key.blank?
      render json: { errors: ["Idempotency key not found"] }, status: :unprocessable_entity
    else
      game = TicTacToe::Game.new(id: params[:id], token:)
      game.player_move(
        position: params[:position],
        idempotency_key:
      )

      if game.winner.empty? && game.turn == "computer"
        game.computer_move(idempotency_key:)
      end
      render locals: { game_info: game }
    end
  end

  private

  def game_not_found(error)
    render json: { errors: [error.message] }, status: :not_found
  end

  def invalid_token(error)
    render json: { errors: [error.message] }, status: :unauthorized
  end

  def invalid_move(error)
    render json: { errors: [error.message] }, status: :conflict
  end

  def check_idempotency_key
    request.headers["Idempotency-Key"]
  end
end
