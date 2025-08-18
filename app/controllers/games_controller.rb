# frozen_string_literal: true

ERRORS = [
  "Game save error",
  "Invalid position",
  "Square already taken",
  "Game completed"
].freeze

class GamesController < ApplicationController
  def index
    game_info = TicTacToe::Game.new_game(params[:player])

    render locals: { game_info: }
  end

  def show
    game_info = TicTacToe::Game.load_game(params[:id])
    render locals: { game_info: }
  end

  def update
    response = TicTacToe::Moves.player_move(params[:id], params[:position])

    if ERRORS.include? response
      render json: { errors: response } if response.is_a?(String)
    elsif response.winner.empty?
      response = TicTacToe::Moves.computer_move(params[:id])
      render locals: { game_info: response }
    else
      render locals: { game_info: response }
    end
  end
end
