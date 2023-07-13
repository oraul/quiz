# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Alternative do
  subject(:alternative) { create(:alternative) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to allow_values([true, false]).for(:correct) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:question) }
    it { is_expected.to have_many(:answers).dependent(:delete_all) }
  end

  describe '.cache_by' do
    subject(:cache_by) { described_class.cache_by(id) }

    let(:id) { alternative.id }

    let(:cache_mock) { object_double(Rails.cache) }

    before do
      allow(Rails).to receive(:cache).and_return(cache_mock)
      allow(cache_mock).to receive(:fetch).with("alternative.#{id}",
                                                expires_in: 10.minutes).and_return(alternative.attributes)
    end

    it { is_expected.to have_attributes(**alternative.attributes) }
  end
end
