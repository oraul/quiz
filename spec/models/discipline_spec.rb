# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Discipline do
  describe 'validations' do
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
  end

  describe 'associations' do
    it { is_expected.to have_many(:topics).dependent(:delete_all) }
  end

  describe 'most_answered' do
    subject(:most_answered) do
      described_class.where(id: (answers.map(&:id) << another_answer.id)).most_answered(1.minute.ago)
    end

    let(:answers) { create_list(:answer, 2, alternative:) }
    let(:another_answer) { create(:answer, created_at: 2.minutes.ago) }
    let(:alternative) { create(:alternative) }
    let(:discipline) { alternative.question.topic.discipline }

    it do
      expect(most_answered).to contain_exactly(
        have_attributes(id: discipline.id, name: discipline.name, answers_count: 2)
      )
    end
  end
end
