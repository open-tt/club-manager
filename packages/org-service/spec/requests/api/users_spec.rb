# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Users API', type: :request do
  before do
    Rails.application.load_seed
    @admin_user = User.create!(
      {
        name: 'overseer',
        email: 'over@test.com',
        is_enabled: true,
        password: '123123',
        password_confirmation: '123123'
      }
    )
    @admin_user.roles_users.create!(role_id: Role.admin.id, org_id: 1)
  end

  path '/users' do
    post 'Creates New User' do
      tags 'Users'

      # operationId 'createUser'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          email: { type: :string },
          password: { type: :string },
          password_confirmation: { type: :string },
          is_enabled: { type: :boolean }
        },
        required: %w[name email password password_confirmation]
      }

      response '201', 'User created successfully' do
        schema '$ref' => '#/components/schemas/registration_success'

        let(:user) do
          {
            name: 'jon doe',
            email: 'jd@testmail.com',
            password: 'jdpass',
            password_confirmation: 'jdpass'
          }
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['success']).to eq(true)
        end
      end

      response '409', 'User creation failed with invalid email' do
        schema '$ref' => '#/components/schemas/registration_failure'
        let(:user) do
          {
            name: 'jon doe',
            email: 'not-an-email',
            password: 'jdpass',
            password_confirmation: 'jdpass'
          }
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['success']).to eq(false)
          expect(data['messages']).to include('Email is invalid')
        end
      end
    end
  end

  path '/users/{id}' do
    get 'Get User by ID' do
      tags 'Users'

      security [{ bearer_auth: [] }]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :id, in: :path, type: :integer

      response '200', 'User profile retrieved successfully' do
        let(:user) do
          user = User.create!(
            {
              name: 'jon doe',
              email: 'jd@testmail.com',
              password: 'jdpass',
              password_confirmation: 'jdpass'
            }
          )
          user.roles = [Role.player]
          user
        end

        let(:Authorization) { "Bearer #{JsonWebToken.encode(user_id: user.id)}" }
        let(:id) { user.id }
        run_test! do
          data = JSON.parse(response.body)
          expect(data['success']).to eq(true)
          expect(data).to have_key('user')
          expect(data['user']).to have_key('name')
        end
      end
    end

    put 'Edits existing User' do
      before do
        @user = User.create!(
          { name: 'jon doe', email: 'jd@testmail.com', password: 'jdpass', password_confirmation: 'jdpass' }
        )
        @user.roles = [Role.player]
      end

      tags 'Users'

      security [{ bearer_auth: [] }]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :id, in: :path, type: :integer
      parameter name: :user_update, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          is_enabled: { type: :boolean },
          profile_image: { type: :string }
        }
      }

      response '204', 'Update User fields successfully' do
        let(:user_update) do
          {
            name: 'updated jon'
          }
        end
        let(:id) { @user.id }
        let(:Authorization) { "Bearer #{JsonWebToken.encode(user_id: @user.id)}" }

        run_test!
      end

      response '404', 'Update User fails with non-existent user id' do
        let(:user_update) { {name: 'updated jon'} }
        let(:id) { 999 }
        let(:Authorization) { "Bearer #{JsonWebToken.encode(user_id: @user.id)}" }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['success']).to eq(false)
          expect(data['message']).to eq('User does not exist')
        end
      end

      response '422', 'Update User fails edit on empty name' do
        let(:user_update) { { name: '' } }
        let(:id) { @user.id }
        let(:Authorization) { "Bearer #{JsonWebToken.encode(user_id: @user.id)}" }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['success']).to eq(false)
          expect(data['messages']).to include("Name can't be blank")
        end
      end

      response '422', 'Update User fails edit when no params passed' do
        let(:user_update) { {} }
        let(:id) { @user.id }
        let(:Authorization) { "Bearer #{JsonWebToken.encode(user_id: @user.id)}" }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['success']).to eq(false)
          expect(data['message']).to eq('No fields to update')
        end
      end
    end
  end

  path '/users/{id}/roles' do
    post 'Add Role' do
      before do
        @user = User.create!(
          { name: 'jon doe', email: 'jd@testmail.com', password: 'jdpass', password_confirmation: 'jdpass' }
        )
      end

      tags 'Users'

      security [{ bearer_auth: [] }]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :id, in: :path, type: :integer
      parameter name: :role, in: :query, type: :string, enum: Role.default_roles, required: true
      parameter name: :org_id, in: :query, type: :integer, required: true

      response '204', 'Add Role' do
        let(:role) { Role.player.name }
        let(:org_id) { 1 }
        let(:id) { @user.id }
        let(:Authorization) { "Bearer #{JsonWebToken.encode(user_id: @admin_user.id)}" }

        run_test! do
          expect(@user.roles.pluck(:name)).to include(role)
        end
      end
    end

    delete 'Remove a Role' do
      before do
        @user = User.create!(
          { name: 'jon doe', email: 'jd@testmail.com', password: 'jdpass', password_confirmation: 'jdpass' }
        )
        @role = Role.player
        RolesUsers.create!(user_id: @user.id, role_id: @role.id, org_id: 1)
        puts 1
      end

      tags 'Users'

      security [{ bearer_auth: [] }]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :id, in: :path, type: :integer
      parameter name: :role, in: :query, type: :string, enum: Role.default_roles, required: true
      parameter name: :org_id, in: :query, type: :integer, required: true

      response '204', 'Remove a Role' do
        let(:role) { @role.name }
        let(:org_id) { 1 }
        let(:id) { @user.id }
        let(:Authorization) { "Bearer #{JsonWebToken.encode(user_id: @admin_user.id)}" }

        run_test! do
          expect(@user.roles.pluck(:name)).to_not include(@role.name)
        end
      end
    end
  end

end
