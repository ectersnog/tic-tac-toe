# frozen_string_literal: true

json.id game_info.id
json.board game_info.board.board
json.board_view game_info.board.board_view
json.turn game_info.turn
json.player game_info.player.marker
json.computer game_info.computer.marker
json.status game_info.status
json.winner game_info.winner
json.last_move_player game_info.player.last_move
json.last_move_computer game_info.computer.last_move
