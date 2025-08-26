# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'victory conditions' do
  path '/games/{id}' do
    parameter name: :id, in: :path, type: :string
    parameter name: 'X-Game-Token', in: :header, type: :string
    parameter name: 'Idempotency-Key', in: :header, type: :string

    post('play move') do
      produces 'application/json'
      consumes 'application/json'

      parameter name: :body, in: :body,
        schema: {
          type: :object,
          properties: {
            position: { type: :integer }
          },
          required: ['position']
        }

      victory_conditions = [
        [0, 1, 2],
        [3, 4, 5],
        [6, 7, 8],
        [0, 3, 6],
        [1, 4, 7],
        [2, 5, 8],
        [0, 4, 8],
        [2, 4, 6]
      ]

      victory_conditions.each do |positions|
        response 200, 'play a move' do
          schema "$ref" => "#/components/schemas/board_response"
          let(:winning_game) { create_winning_game(positions.take(2)) }
          let(:game) { winning_game }
          let(:id) { winning_game.id }
          let(:'X-Game-Token') { winning_game.token }
          let(:'Idempotency-Key') { SecureRandom.hex(10) }
          let(:body) { { position: positions.last + 1 } }

          run_test! do |response|
            data = JSON.parse(response.body, symbolize_names: true)
            data = TicTacToe::GameInfo.new(**data, token: winning_game.token)
            expect(data.status).to eq('completed')
            expect(data.winner).to eq('player')
          end
        end
      end
    end
  end
end
