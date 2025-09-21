# frozen_string_literal: true

module TicTacToe
  module Moves
    def player_move(position:, idempotency_key:)
      if (cached = REDIS.get("idempotency:#{@id}:#{idempotency_key}"))
        return self.from_json(cached)
      end

      position = position.to_i - 1
      raise InvalidMove, "Invalid position" if position > 8 || position.negative?
      raise InvalidMove, "Game completed" if Victory.game_won?(self)
      raise InvalidMove, "Square already taken" unless @board.square_free?(position)

      @board.play_square(position, @player)
      @player.last_move = position
      @turn = "computer"
      if Victory.check_winner(@board.board, @player.marker)
        @winner = "player"
        @status = "completed"
      end
      REDIS.setex("idempotency:#{@id}:#{idempotency_key}", 3600, to_json)
      self.game_save
    end

    def computer_move(idempotency_key:)
      positions = @board.available_positions
      if positions.empty?
        @status = "completed"
        @winner = "draw"
        self.game_save
        return
      end

      computer_win = find_winning(@board.board, @computer.marker, positions)
      player_win = find_winning(@board.board, @player.marker, positions)
      if computer_win
        @board.play_square(computer_win, @computer)
        position = computer_win
      elsif player_win
        @board.play_square(player_win, @computer)
        position = player_win
      else
        position = positions.shuffle.pop
        @board.play_square(position, @computer)
      end
      @computer.last_move = position
      @turn = "player"

      if Victory.check_winner(@board.board, @computer.marker)
        @winner = "computer"
        @status = "completed"
      end
      REDIS.setex("idempotency:#{@id}:#{idempotency_key}", 3600, to_json)
      game_save
    end

    def find_winning(board, player, positions)
      positions.each do |position|
        tmp_game = board.dup
        tmp_game[position] = player
        if Victory.check_winner(tmp_game, player)
          tmp_game[position] = "-"
          return position
        end
        tmp_game[position] = "-"
      end
      nil
    end
  end
end
