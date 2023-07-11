# frozen_string_literal: true

class AlternativesController < ApplicationController
  before_action :set_alternative, only: %i[show update destroy]

  # GET /alternatives
  # GET /alternatives.json
  def index
    @alternatives = Alternative.all
  end

  # GET /alternatives/1
  # GET /alternatives/1.json
  def show; end

  # POST /alternatives
  # POST /alternatives.json
  def create
    @alternative = Alternative.new(alternative_params)

    if @alternative.save
      render :show, status: :created, location: @alternative
    else
      render json: @alternative.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /alternatives/1
  # PATCH/PUT /alternatives/1.json
  def update
    if @alternative.update(alternative_params)
      render :show, status: :ok, location: @alternative
    else
      render json: @alternative.errors, status: :unprocessable_entity
    end
  end

  # DELETE /alternatives/1
  # DELETE /alternatives/1.json
  def destroy
    @alternative.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_alternative
    @alternative = Alternative.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def alternative_params
    params.require(:alternative).permit(:description, :question_id, :correct)
  end
end
