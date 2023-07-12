# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserEntity, type: :entity do
  subject(:user_entity) do
    build(
      :user_entity,
      **attributes
    )
  end

  let(:attributes) do
    {
      sub: 'dbdc2419-f6cf-49c8-a545-a908a03741ce',
      name: 'John Doe',
      exp: 24.hours.from_now.to_i,
      iss: 'auth',
      aud: 'quiz'
    }
  end

  it { is_expected.to have_attributes(attributes) }
end
