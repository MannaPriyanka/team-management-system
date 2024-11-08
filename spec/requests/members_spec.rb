require 'swagger_helper'

RSpec.describe 'teams', type: :request do
  # Define an Authorization header if needed for authenticated requests
  let(:Authorization) { "Bearer your_auth_token" } # Replace with a valid token for testing

  path '/' do
    get('list teams') do
      response(200, 'successful') do
        let(:headers) { { 'Authorization' => Authorization } } # Pass the header if authentication is required

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end
  end

  path '/teams' do
    get('list teams') do
      response(200, 'successful') do
        let(:headers) { { 'Authorization' => Authorization } }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end

    post('create team') do
      response(200, 'successful') do
        let(:headers) { { 'Authorization' => Authorization } }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end
  end

  path '/teams/{id}' do
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('show team') do
      response(200, 'successful') do
        let(:id) { '123' }
        let(:headers) { { 'Authorization' => Authorization } }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end

    patch('update team') do
      response(200, 'successful') do
        let(:id) { '123' }
        let(:headers) { { 'Authorization' => Authorization } }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end

    put('update team') do
      response(200, 'successful') do
        let(:id) { '123' }
        let(:headers) { { 'Authorization' => Authorization } }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end

    delete('delete team') do
      response(200, 'successful') do
        let(:id) { '123' }
        let(:headers) { { 'Authorization' => Authorization } }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end
  end
end
