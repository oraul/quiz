# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Alternative do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_inclusion_of(:correct).in_array([true, false]) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:question) }
  end
end
