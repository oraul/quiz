# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Answer do
  subject(:answer) { build(:answer) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:user_id) }
    it { is_expected.to validate_presence_of(:alternative_id) }

    context 'when is invalid alternative_id' do
      before { answer.alternative_id = SecureRandom.uuid }

      it { expect { answer.save }.to raise_error(ActiveRecord::InvalidForeignKey) }
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:alternative).optional(true) }
  end
end
