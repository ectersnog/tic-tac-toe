# frozen_string_literal: true

module Schemas
  module Board
    def self.schema
      {
        board_response: {
          type: :object,
          properties: {
            id: { type: :string },
            board: {
              type: :array,
              items: {
                type: :string,
                enum: %w[X O -]
              },
              minItems: 9,
              maxItems: 9
            },
            board_view: {
              type: :array,
              minItems: 3,
              maxItems: 3,
              items: {
                type: :array,
                minItems: 3,
                maxItems: 3,
                items: {
                  type: :string,
                  enum: %w[X O -]
                }
              }
            },
            turn: { type: :string },
            player: { type: :string },
            computer: { type: :string },
            status: { type: :string },
            winner: { type: :string },
            last_move_player: { type: :integer },
            last_move_computer: { type: :integer }
          },
          required: %w[id board board_view turn player computer status winner last_move_player last_move_computer]
        }
      }
    end
  end
end
