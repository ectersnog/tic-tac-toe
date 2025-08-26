# frozen_string_literal: true

require_relative 'board'
require_relative 'game_info'

module TicTacToe
  class Game
    def self.new_game(player = "X")
      unless %w[X O].include? player
        player = "X"
      end
      id = SecureRandom.uuid
      board = Board.generate_board
      board_view = Board.generate_board_view(board)
      turn = "player"
      computer = player == "X" ? "O" : "X"
      status = "active"
      winner = ""
      last_move_player = 0
      last_move_computer = 0
      token = Token.generate_token

      game = GameInfo.new(
        id:,
        board:,
        board_view:,
        turn:,
        player:,
        computer:,
        status:,
        winner:,
        last_move_player:,
        last_move_computer:,
        token:
      )

      return nil unless game_save(game)

      game
    end

    def self.game_save(game)
      board = JSON.dump(game.board)
      board_view = JSON.dump(Board.generate_board_view(game.board))
      game_save = game.with(board:, board_view:)
      game_hash = game_save.to_h.transform_keys(&:to_s)
      REDIS.hset(game.id, game_hash)
      game.with(board_view: Board.generate_board_view(game.board))
    end

    def self.load_game(id)
      raw = REDIS.hgetall(id)
      parsed = raw.transform_keys(&:to_sym)
      parsed[:board] = JSON.parse(parsed[:board])
      parsed[:board_view] = JSON.parse(parsed[:board_view])
      parsed[:last_move_player] = parsed[:last_move_player].to_i
      parsed[:last_move_computer] = parsed[:last_move_computer].to_i
      GameInfo.new(**parsed)
    end

    def self.game_exists?(id)
      REDIS.exists(id)
    end
  end
end
