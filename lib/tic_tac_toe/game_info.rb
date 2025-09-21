# frozen_string_literal: true

module TicTacToe
  # Game not found error
  class GameNotFound < StandardError; end
  # Invalid Token for game error
  class InvalidToken < StandardError; end
  # Invalid Move for game play error
  class InvalidMove < StandardError; end
end
