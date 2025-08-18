# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'games' do
  path '/games' do
    post('new game') do
      consumes 'application/json'
      produces 'application/json
'
      parameter name: :player, in: :body, schema: {
        type: :object,
        properties: {
          player: {
            type: :string,
            enum: %w[X O]
          }
        },
        required: ['player']
      }

      response 200, 'success' do
        schema "$ref" => "#/components/schemas/board_response"

        let(:player) { 'X' }

        run_test!
      end

      response 200, 'default player to X' do
        let(:player) { 'q' }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['player']).to eq('X')
        end
      end
    end
  end

  path '/games/{id}' do
    parameter name: :id, in: :path, type: :string

    get('show game') do
      produces 'application/json'

      response 200, 'success' do
        schema "$ref" => "#/components/schemas/board_response"

        let(:id) { TicTacToe::Game.new_game.id }

        run_test!
      end
    end
  end
end
