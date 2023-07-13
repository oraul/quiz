# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersController do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/answers').to route_to('answers#index')
    end

    it 'routes to #show' do
      expect(get: '/answers/1').to route_to('answers#show', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/answers').to route_to('answers#create')
    end

    it 'routes to #destroy' do
      expect(delete: '/answers/1').to route_to('answers#destroy', id: '1')
    end
  end
end
