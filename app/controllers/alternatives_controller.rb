# frozen_string_literal: true

class AlternativesController < ApplicationController
  before_action :set_alternative, only: %i[show]

  # GET /alternatives/1
  # GET /alternatives/1.json
  def show; end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_alternative
    @alternative = Alternative.cache_by(params[:id])
  end
end
