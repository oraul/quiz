# frozen_string_literal: true

class MostAnsweredController < ApplicationController
  def disciplines
    @disciplines = Discipline.most_answered
  end
end
