# frozen_string_literal: true

ERRORS = [
  "Invalid position",
  "Square already taken",
  "Game completed"
].freeze

class GamesController < ApplicationController
  rescue_from TicTacToe::Game::GameNotFound, with: :game_not_found
  rescue_from TicTacToe::Game::InvalidToken, with: :invalid_token

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
    # game_info = TicTacToe::Game.find_game(params[:id])
    render locals: { game_info: }
  end

  def update
    idempotency_key = request.headers["Idempotency-Key"]
    token = request.headers["X-Game-Token"]
    move_request = TicTacToe::MoveRequest.new(
      id: params[:id],
      position: params[:position],
      idempotency_key:)

    response = TicTacToe::Moves.player_move(
      move_request:,
      token:)

    if ERRORS.include? response
      render json: { errors: [response] }, status: :conflict
    elsif response.winner.empty? && response.turn == "computer"
      response = TicTacToe::Moves.computer_move(move_request:, token:)
      render locals: { game_info: response }
    else
      render locals: { game_info: response }
    end
  end

  private

  def game_not_found(error)
    render json: { errors: [error.message] }, status: :not_found
  end

  def invalid_token(error)
    render json: { errors: [error.message] }, status: :unauthorized
  end

  def check_idempotency_key
    idempotency_key = request.headers["Idempotency-Key"]
    render json: { errors: ["Idempotency key not found"] }, status: :unprocessable_entity if idempotency_key.blank?
  end
end
