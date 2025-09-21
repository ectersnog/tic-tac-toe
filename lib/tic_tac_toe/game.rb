# frozen_string_literal: true

require_relative 'board'
require_relative 'game_info'
require_relative 'moves'

module TicTacToe
  class Game
    include Moves
    attr_accessor :status

    attr_reader :board,
      :board_view,
      :player,
      :computer,
      :id,
      :turn,
      :winner,
      :token

    def initialize(id: nil, player: "X", token: nil)
      find_game(id:, player:, token:)
    end

    def new_game(player: "X")
      @id = SecureRandom.uuid
      @player = Player.new(marker: "X", last_move: 0)
      @player.marker = "O" if player == "O"
      @computer = Player.new(marker: (@player.marker == "X" ? "O" : "X"), last_move: 0)
      @board = Board.new
      @turn = "player"
      @status = "active"
      @winner = ""
      @token = SecureRandom.hex(10)

      self.game_save
    end

    def game_save
      game_hash = {
        board: @board.board_json,
        board_view: @board.board_view_json,
        turn: @turn,
        player: @player.marker,
        computer: @computer.marker,
        status: @status,
        winner: @winner,
        last_move_player: @player.last_move,
        last_move_computer: @computer.last_move,
        token: @token
      }
      REDIS.hset(@id, game_hash)
      self
    end

    def find_game(id: nil, player: "X", token: nil)
      if id.nil?
        new_game(player:)
      elsif REDIS.exists?(id)
        raw = REDIS.hgetall(id)
        parsed = raw.transform_keys(&:to_sym)
        raise InvalidToken, "Invalid token" if parsed[:token] != token

        @id = id
        @player = Player.new(marker: parsed[:player], last_move: parsed[:last_move_player].to_i)
        @computer = Player.new(marker: parsed[:computer], last_move: parsed[:last_move_computer].to_i)
        @board = Board.new(JSON.parse(parsed[:board]))
        @turn = parsed[:turn]
        @status = parsed[:status]
        @winner = parsed[:winner]
        @token = parsed[:token]
      else
        raise GameNotFound, "Game not found"
      end
    end

    def from_json(json_string)
      parsed = JSON.parse(json_string, symbolize_names: true)
      @id = parsed[:id]
      @player = Player.new(marker: parsed[:player], last_move: parsed[:last_move_player])
      @computer = Player.new(marker: parsed[:computer], last_move: parsed[:last_move_computer])
      @board = Board.new(JSON.parse(parsed[:board]))
      @turn = parsed[:turn]
      @status = parsed[:status]
      @winner = parsed[:winner]
      @token = parsed[:token]
      self
    end

    def to_json(*_args)
      {
        id: @id,
        board: @board.board_json,
        board_view: @board.board_view_json,
        turn: @turn,
        player: @player.marker,
        computer: @computer.marker,
        status: @status,
        winner: @winner,
        last_move_player: @player.last_move,
        last_move_computer: @computer.last_move,
        token: @token
      }.to_json
    end
  end
end
