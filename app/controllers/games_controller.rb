# frozen_string_literal: true

ERRORS = [
  "Game save error",
  "Invalid position",
  "Square already taken",
  "Game completed"
].freeze

class GamesController < ApplicationController
  def index
    token = TicTacToe::Token.generate_token
    game_info = TicTacToe::Game.new_game(params[:player])
    TicTacToe::Token.set_token(game_info.id, token)

    render locals: { game_info:, game_token: token }
  end

  def show
    token = request.headers["X-Game-Token"]
    if TicTacToe::Token.valid?(params[:id], token)
      game_info = TicTacToe::Game.load_game(params[:id])
      render locals: { game_info: }
    else
      render json: { errors: "invalid token" }, status: :unauthorized
    end
  end

  def update
    move_request = TicTacToe::MoveRequest.new(params[:id], params[:position], request.headers["Idempotency-Key"])

    response = TicTacToe::Moves.player_move(params[:id], params[:position], move_request)

    if ERRORS.include? response
      render json: { errors: response }
    elsif response.winner.empty? && response.turn == "computer"
      response = TicTacToe::Moves.computer_move(params[:id], move_request)
      render locals: { game_info: response }
    else
      render locals: { game_info: response }
    end
  end
end
