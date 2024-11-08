require 'swagger_helper'

RSpec.describe 'members', type: :request do
  let(:Authorization) { "Bearer your_auth_token" } # Replace with a valid token for testing
  let(:team_id) { '1' } # Replace with a valid team ID for testing

  path '/teams/{team_id}/members' do
    parameter name: :team_id, in: :path, type: :string, description: 'ID of the team'

    get('list members') do
      tags 'Members'
      produces 'application/json'
      parameter name: :last_name, in: :query, type: :string, description: 'Search members by last name'
      parameter name: :page, in: :query, type: :integer, description: 'Page number for pagination'
      parameter name: :per_page, in: :query, type: :integer, description: 'Items per page for pagination'

      response(200, 'successful') do
        let(:headers) { { 'Authorization' => Authorization } }
        let(:last_name) { 'Smith' }
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

    post('create member') do
      tags 'Members'
      produces 'application/json'
      consumes 'application/json'
      parameter name: :member, in: :body, schema: {
        type: :object,
        properties: {
          first_name: { type: :string },
          last_name: { type: :string },
          email: { type: :string },
          user_id: { type: :integer }
        },
        required: ['first_name', 'last_name', 'email']
      }

      response(201, 'created') do
        let(:headers) { { 'Authorization' => Authorization } }
        let(:member) { { first_name: 'John', last_name: 'Doe', email: 'john.doe@example.com', user_id: 1 } }

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
        let(:headers) { { 'Authorization' => Authorization } }
        let(:member) { { first_name: '' } } # Invalid member params

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: { errors: ['First name can\'t be blank'] }
            }
          }
        end
        run_test!
      end
    end
  end

  path '/teams/{team_id}/members/{id}' do
    parameter name: :team_id, in: :path, type: :string, description: 'ID of the team'
    parameter name: :id, in: :path, type: :string, description: 'ID of the member'

    delete('delete member') do
      tags 'Members'
      produces 'application/json'

      response(204, 'no content') do
        let(:headers) { { 'Authorization' => Authorization } }
        let(:id) { '1' } # Replace with a valid member ID for testing

        run_test!
      end

      response(404, 'not found') do
        let(:headers) { { 'Authorization' => Authorization } }
        let(:id) { 'invalid' } # Invalid member ID

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: { error: 'Member not found' }
            }
          }
        end
        run_test!
      end
    end
  end
end
