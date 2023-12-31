# frozen_string_literal: true

Rails.application.routes.draw do
  get :health, to: ->(_env) { [204, {}, ['']] }
  namespace :most_answered do
    get :disciplines
  end
  resources :alternatives, only: [:show]
  resources :answers, only: %i[index show create destroy]
  resources :questions
  resources :disciplines
  resources :topics
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  # Defines the root path route ("/")
  # root "articles#index"
end
