# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Question do
  subject(:question) { build(:question) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:enunciation) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:topic) }
    it { is_expected.to have_many(:alternatives).dependent(:delete_all) }
  end
end
