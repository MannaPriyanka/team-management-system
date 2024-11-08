require 'swagger_helper'

RSpec.describe 'teams', type: :request do
  path '/teams' do
    get('list teams') do
      tags 'Teams'
      produces 'application/json'
      parameter name: :page, in: :query, type: :integer, description: 'Page number for pagination'
      parameter name: :per_page, in: :query, type: :integer, description: 'Items per page for pagination'

      response(200, 'successful') do
        let(:page) { 1 }
        let(:per_page) { 10 }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end

      response(401, 'unauthorized') do
        let(:Authorization) { 'Bearer invalid_token' }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: { error: 'Unauthorized' }
            }
          }
        end
        run_test!
      end
    end

    post('create team') do
      tags 'Teams'
      produces 'application/json'
      consumes 'application/json'
      parameter name: :team, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          description: { type: :string }
        },
        required: ['name']
      }

      response(201, 'created') do
        let(:team) { { name: 'New Team', description: 'Team description' } }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end

      response(422, 'unprocessable entity') do
        let(:team) { { name: '' } } # Invalid team params

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: { errors: ['Name can\'t be blank'] }
            }
          }
        end
        run_test!
      end
    end
  end

  path '/teams/{id}' do
    parameter name: :id, in: :path, type: :string, description: 'ID of the team'

    get('show team') do
      tags 'Teams'
      produces 'application/json'

      response(200, 'successful') do
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end

      response(404, 'not found') do
        let(:id) { 'invalid' }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: { error: 'Team not found' }
            }
          }
        end
        run_test!
      end
    end

    patch('update team') do
      tags 'Teams'
      produces 'application/json'
      consumes 'application/json'
      parameter name: :team, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          description: { type: :string }
        }
      }

      response(200, 'successful') do
        let(:id) { '123' }
        let(:team) { { name: 'Updated Team Name', description: 'Updated Description' } }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end

      response(404, 'not found') do
        let(:id) { 'invalid' }
        let(:team) { { name: 'Updated Team Name', description: 'Updated Description' } }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: { error: 'Team not found' }
            }
          }
        end
        run_test!
      end

      response(422, 'unprocessable entity') do
        let(:id) { '123' }
        let(:team) { { name: '' } } # Invalid team params

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: { errors: ['Name can\'t be blank'] }
            }
          }
        end
        run_test!
      end
    end

    delete('delete team') do
      tags 'Teams'
      produces 'application/json'

      response(204, 'no content') do
        let(:id) { '123' }

        run_test!
      end

      response(404, 'not found') do
        let(:id) { 'invalid' }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: { error: 'Team not found' }
            }
          }
        end
        run_test!
      end
    end
  end
end
