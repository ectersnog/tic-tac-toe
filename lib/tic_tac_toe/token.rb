# frozen_string_literal: true

module TicTacToe
  module Token
    def self.valid?(game_id, token)
      REDIS.get("#{game_id}_token") == token
    end

    def self.set_token(game_id, token)
      REDIS.set("#{game_id}_token", token)
    end

    def self.generate_token
      SecureRandom.hex(10)
    end
  end
end
