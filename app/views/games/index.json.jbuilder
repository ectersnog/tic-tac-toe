# frozen_string_literal: true

json.partial! 'game', locals: { game_info: }

json.game_token game_info.token
