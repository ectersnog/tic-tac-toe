# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'moves' do
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

      response 200, 'play a move' do
        schema "$ref" => "#/components/schemas/board_response"
        let(:game) { create_game }
        let(:id) { game.id }
        let(:'X-Game-Token') { game.token }
        let(:'Idempotency-Key') { SecureRandom.hex(10) }
        let(:body) { { position: 1 } }

        run_test!
      end

      response 200, 'returns an error on already take square' do
        let(:game) { create_game }
        let(:id) { game.id }
        let(:'X-Game-Token') { game.token }
        let(:'Idempotency-Key') { SecureRandom.hex(10) }
        let(:position) { 1 }
        let(:body) { { position: } }

        run_test! do |first_response|
          data = JSON.parse(first_response.body, symbolize_names: true)
          data = TicTacToe::GameInfo.new(**data, token: game.token)
          expect(data.board[position - 1]).to eq(data.player)

          post "/games/#{id}",
            params: { position: }.to_json,
            headers: {
              'Content-Type' => 'application/json',
              'X-Game-Token' => game.token,
              'Idempotency-Key' => SecureRandom.hex(10)
            }

          expect(response).to have_http_status(:conflict)
          error_body = JSON.parse(response.body, symbolize_names: true)
          expect(error_body[:errors][0]).to eq('Square already taken')
        end
      end

      response 409, 'returns an error on already finished game' do
        schema "$ref" => "#/components/schemas/error_response"
        let(:game) { create_game }
        let(:id) { game.id }
        let(:'X-Game-Token') { game.token }
        let(:'Idempotency-Key') { SecureRandom.hex(10) }
        let(:body) { { position: 1 } }
        before do
          game.status = 'completed'
          game.game_save
        end

        run_test!
      end

      response 409, 'returns an error on invalid position' do
        schema "$ref" => "#/components/schemas/error_response"
        let(:game) { create_game }
        let(:id) { game.id }
        let(:'X-Game-Token') { game.token }
        let(:'Idempotency-Key') { SecureRandom.hex(10) }
        let(:body) { { position: 10 } }

        run_test!
      end

      response 422, 'returns an error if missing idempotency-key' do
        schema "$ref" => "#/components/schemas/error_response"
        let(:game) { create_game }
        let(:id) { game.id }
        let(:'X-Game-Token') { game.token }
        let(:body) { { position: 1 } }
        let(:'Idempotency-Key') {}

        run_test!
      end
    end
  end
end
