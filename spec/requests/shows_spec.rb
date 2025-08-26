# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'moves' do
  path '/games/{id}' do
    parameter name: :id, in: :path, type: :string
    parameter name: 'X-Game-Token', in: :header, type: :string

    get('show game') do
      produces 'application/json'
      consumes 'application/json'

      response 200, 'success' do
        schema "$ref" => "#/components/schemas/board_response"
        let(:game) { create_game }
        let(:id) { game.id }
        let(:'X-Game-Token') { game.token }

        run_test!
      end

      response 401, 'unauthorised with invalid token' do
        schema "$ref" => "#/components/schemas/error_response"
        let(:game) { create_game }
        let(:id) { game.id }
        let(:'X-Game-Token') { 'not valid' }

        run_test!
      end

      response 401, 'no game token provided' do
        schema "$ref" => "#/components/schemas/error_response"
        let(:game) { create_game }
        let(:id) { game.id }
        let(:'X-Game-Token') {}

        run_test!
      end

      response 404, 'game not found' do
        schema "$ref" => "#/components/schemas/error_response"
        let(:'X-Game-Token') { 'frog' }
        let(:id) { "invalid" }

        run_test!
      end
    end
  end
end
