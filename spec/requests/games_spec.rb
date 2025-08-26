# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'games' do
  path '/games' do
    post('new game') do
      consumes 'application/json'
      produces 'application/json'
      parameter name: :player_symbol, in: :body, schema: {
        type: :object,
        properties: {
          player: {
            type: :string,
            enum: %w[X O]
          }
        }
      }

      response 200, 'success' do
        schema "$ref" => "#/components/schemas/board_response"
        let(:player_symbol) {}

        run_test!
      end

      response 200, 'default player to X' do
        schema "$ref" => "#/components/schemas/board_response"
        let(:player_symbol) { { player: 'Q' } }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['player']).to eq('X')
        end
      end

      response 200, 'allow player to play as O' do
        schema "$ref" => "#/components/schemas/board_response"
        let(:player_symbol) { { player: 'O' } }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['player']).to eq("O")
        end
      end
    end
  end
end
