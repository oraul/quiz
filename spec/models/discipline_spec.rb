# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Discipline do
  describe 'validations' do
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
  end
end
