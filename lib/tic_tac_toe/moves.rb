# frozen_string_literal: true

module TicTacToe
  module Moves
    def self.player_move(id, position)
      game = Game.load_game(id)
      position = position.to_i - 1
      return "Invalid position" if position > 8 || position.negative?
      return "Game completed" if Victory.game_won?(game)
      return "Square already taken" unless check_position?(game, position)

      game.board[position] = game.player
      game = game.with(last_move_player: position + 1)
      if Victory.check_winner(game, game.player)
        game = game.with(winner: "player", status: "completed")
      end
      Game.game_save(game)
      game
    end

    def self.computer_move(id)
      game = Game.load_game(id)
      positions = [0, 1, 2, 3, 4, 5, 6, 7, 8].shuffle
      position = positions.pop
      until check_position?(game, position)
        position = positions.pop
        if positions.empty?
          return Game.game_save(game.with(winner: "draw", status: "completed"))
        end
        return "No valid positions" if positions.empty?
      end
      game.board[position] = game.computer
      game = game.with(last_move_computer: position + 1)
      if Victory.check_winner(game, game.computer)
        game = game.with(winner: "computer", status: "completed")
      end
      Game.game_save(game)
      Game.load_game(game.id)
    end

    def self.check_position?(game, position)
      game.board[position] == "-"
    end
  end
end
