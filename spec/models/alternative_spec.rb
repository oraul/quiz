# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Alternative do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to allow_values([true, false]).for(:correct) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:question) }
  end
end
