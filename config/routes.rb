# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :most_answered do
    get :disciplines
  end
  resources :alternatives, only: [:show]
  resources :answers
  resources :questions
  resources :disciplines
  resources :topics
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
