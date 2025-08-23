# frozen_string_literal: true

module TicTacToe
  module Moves
    def self.player_move(id, position, move_request)
      if (cached = REDIS.get("idempotency:#{id}:#{move_request.idempotency_key}"))
        game = GameInfo.new(**JSON.parse(cached))
        game = game.with(turn: "player")
        return Game.game_save(game)
      end

      game = Game.load_game(id)
      position = position.to_i - 1
      return "Invalid position" if position > 8 || position.negative?
      return "Game completed" if Victory.game_won?(game)
      return "Square already taken" unless check_position?(game, position)

      game.board[position] = game.player
      game = game.with(
        last_move_player: position + 1,
        turn: "computer",
        board_view: Board.generate_board_view(game.board)
      )
      if Victory.check_winner(game, game.player)
        game = game.with(winner: "player", status: "completed")
      end
      Game.game_save(game)
    end

    def self.computer_move(id, move_request)
      game = Game.load_game(id)
      positions = get_positions(game)
      if positions.empty?
        game = game.with(status: "completed", winner: "draw")
        Game.game_save(game)
        return game
      end

      computer_win = find_winning(game.dup, game.computer, positions)
      player_win = find_winning(game.dup, game.player, positions)
      if computer_win
        game.board[computer_win] = game.computer
        position = computer_win
      elsif player_win
        game.board[player_win] = game.computer
        position = player_win
      else
        position = positions.shuffle.pop
        game.board[position] = game.computer
      end
      game = game.with(
        last_move_computer: position + 1,
        turn: "player",
        board_view: Board.generate_board_view(game.board)
      )
      if Victory.check_winner(game, game.computer)
        game = game.with(winner: "computer", status: "completed")
      end
      REDIS.setex("idempotency:#{id}:#{move_request.idempotency_key}", 3600, game.to_json)
      Game.game_save(game)
    end

    def self.get_positions(game)
      playable = []
      game.board.each_index do |position|
        playable << position if check_position?(game, position)
      end
      playable
    end

    def self.find_winning(game, player, positions)
      positions.each do |position|
        tmp_game = game.dup
        tmp_game.board[position] = player
        if Victory.check_winner(tmp_game, player)
          tmp_game.board[position] = "-"
          return position
        end
        tmp_game.board[position] = "-"
      end
      nil
    end

    def self.check_position?(game, position)
      game.board[position] == "-"
    end
  end
end
