# frozen_string_literal: true

module GameHelpers
  def create_game(player: 'X')
    TicTacToe::Game.new(player:)
  end

  def create_winning_game(positions)
    game = TicTacToe::Game.new
    positions.each do |position|
      game.board.play_square(position, game.player)
    end
    game.game_save
    game
  end

  delegate :get_token, to: :'TicTacToe::Token'
end
