# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Question do
  subject(:question) { create(:question) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:enunciation) }

    it 'is expected to validate that the length of :alternatives is 5' do
      question.alternatives = []
      question.valid?
      expect(question.errors[:alternatives]).to include('is the wrong length (should be 5 objects)')
    end

    it 'is expected to validate that one alternative is correct' do
      question.alternatives = build_list(:alternative, 5, question: nil)
      question.valid?
      expect(question.errors[:alternatives]).to include('is the wrong length (should be 1 correct=true)')
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:topic) }
    it { is_expected.to have_many(:alternatives).dependent(:delete_all) }
  end

  describe 'accepts nested attributes' do
    it { is_expected.to accept_nested_attributes_for(:alternatives).allow_destroy(true) }
  end

  describe '.by_topic_id' do
    subject(:by_topic_id) { described_class.by_topic_id(topic_id) }

    context 'with valid topic_id' do
      let(:topic_id) { question.topic_id }

      it { is_expected.to match_array(question) }
    end

    context 'with unknown topic_id' do
      let(:topic_id) { 'unknown' }

      it { is_expected.to be_empty }
    end
  end

  describe '.by_enunciation_like' do
    subject(:by_enunciation_like) { described_class.by_enunciation_like(enunciation) }

    context 'with part of enunciation and case insensitive' do
      let(:enunciation) { question.enunciation.downcase[2..4] }

      it { is_expected.to match_array(question) }
    end

    context 'with unknown enunciation' do
      let(:enunciation) { 'unknown' }

      it { is_expected.to be_empty }
    end
  end
end
