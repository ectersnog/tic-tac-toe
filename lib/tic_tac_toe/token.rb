# frozen_string_literal: true

module TicTacToe
  module Token
    def self.valid?(game_id, token)
      game = TicTacToe::Game.load_game(game_id)
      game.token == token
    end

    def self.generate_token
      SecureRandom.hex(10)
    end
  end
end
