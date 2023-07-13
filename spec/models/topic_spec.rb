# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Topic do
  subject(:topic) { build(:topic) }

  describe 'validations' do
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:discipline) }
    it { is_expected.to have_many(:questions).dependent(:delete_all) }
  end
end
