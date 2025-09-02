# frozen_string_literal: true

module GameHelpers
  def create_game(player: 'X', status: 'active')
    game = TicTacToe::Game.find_game(player:)
    game = game.with(status:) unless status == 'active'
    TicTacToe::Game.game_save(game)
    game
  end

  def create_winning_game(positions, symbol: 'X')
    game = TicTacToe::Game.find_game
    positions.each do |position|
      game.board[position] = symbol
    end
    TicTacToe::Game.game_save(game)
    game
  end

  delegate :get_token, to: :'TicTacToe::Token'
end
