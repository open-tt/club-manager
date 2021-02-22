require 'swagger_helper'

RSpec.describe 'Tournaments API', type: :request do
  before do
  end

  path '/tournaments' do
    post 'Creates New Tournament' do
      tags 'Tournaments'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :body, in: :body, schema: {
        type: :object,
        properties: {
          user_id: { type: :integer },
          org_id: { type: :integer }
        },
        required: %w[user_id]
      }

      response '201', 'Tournament Created' do
        run_test!
      end
    end

    get 'Index Tournaments' do
      tags 'Tournaments'
      consumes 'application/json'
      produces 'application/json'

      response '200', 'Get all tournaments' do
        run_test!
      end
    end
  end

  path '/tournaments/{id}' do
    delete 'Delete Tournament' do
      tags 'Tournaments'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :id, in: :path, type: :integer

      response '204', 'Tournament Deleted' do
        run_test!
      end
    end

    get 'Retrieve a single tournament' do
      tags 'Tournaments'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :id, in: :path, type: :integer

      response '200', 'Get one tournament by id' do
        run_test!
      end
    end
  end

  path '/tournaments/{id}/players' do
    post 'Adds a player to the tournament' do
      tags 'Tournaments'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :id, in: :path, type: :integer
      parameter name: :body, in: :body, schema: {
        type: :object,
        properties: {
          players: {
            type: :array,
            items: {
              properties: {
                player_id: { type: :integer },
                name: { type: :string },
                rating: { type: :integer }
              },
              required: %w[user_id name rating]
            }
          }
        }
      }

      response '201', 'Add player' do
        run_test!
      end
    end

    delete 'Remove Players' do
      tags 'Tournaments'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :id, in: :path, type: :integer
      parameter name: :body, in: :body, schema: {
        type: :object,
        properties: {
          player_ids: {
            type: :array,
            items: { type: :integer }
          }
        }
      }

      response '204', 'Remove player' do
        run_test!
      end
    end
  end

  path '/tournaments/{id}/groups' do
    post 'Create Groups for the tournament using registered users' do
      tags 'Tournaments'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :id, in: :path, type: :integer

      response '201', 'Create Group' do
        run_test!
      end
    end
  end

  path '/tournaments/{id}/playoffs' do
    post 'Create Playoffs for the tournament from the existing groups' do
      tags 'Tournaments'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :id, in: :path, type: :integer
      parameter name: :body, in: :body, schema: {
        type: :object,
        properties: {
          player_ids: {
            type: :array,
            items: {
              type: :integer
            }
          }
        }
      }

      response '201', 'Create Playoffs' do
        run_test!
      end
    end
  end
end