# frozen_string_literal: true

ERRORS = [
  "Invalid position",
  "Square already taken",
  "Game completed"
].freeze

class GamesController < ApplicationController
  before_action :check_token_presence, only: %i[show update]
  before_action :check_idempotency_key, only: %i[update]

  def index
    game_info = if params[:player]
      TicTacToe::Game.new_game(params[:player])
    else
      TicTacToe::Game.new_game
    end

    render locals: { game_info: }
  end

  def show
    token = request.headers["X-Game-Token"]

    return render json: { errors: ["game not found"] }, status: :not_found if TicTacToe::Game.game_exists?(params[:id]).zero?
    return render json: { errors: ["invalid token"] }, status: :unauthorized unless TicTacToe::Token.valid?(params[:id], token)

    game_info = TicTacToe::Game.load_game(params[:id])
    render locals: { game_info: }
  end

  def update
    idempotency_key = request.headers["Idempotency-Key"]
    move_request = TicTacToe::MoveRequest.new(
      game_id: params[:id],
      position: params[:position],
      idempotency_key:)

    response = TicTacToe::Moves.player_move(
      params[:id],
      params[:position],
      move_request)

    if ERRORS.include? response
      render json: { errors: [response] }, status: :conflict
    elsif response.winner.empty? && response.turn == "computer"
      response = TicTacToe::Moves.computer_move(params[:id], move_request)
      render locals: { game_info: response }
    else
      render locals: { game_info: response }
    end
  end

  private

  def check_token_presence
    token = request.headers["X-Game-Token"]
    render json: { errors: ["game token required"] }, status: :unauthorized if token.blank?
  end

  def check_idempotency_key
    idempotency_key = request.headers["Idempotency-Key"]
    render json: { errors: ["Idempotency key not found"] }, status: :unprocessable_entity if idempotency_key.blank?
  end
end
