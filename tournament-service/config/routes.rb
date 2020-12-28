# frozen_string_literal: true

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  # Tournaments
  post    '/tournaments'      => 'tournaments#create'
  delete  '/tournaments/:id'      => 'tournaments#delete'

end
