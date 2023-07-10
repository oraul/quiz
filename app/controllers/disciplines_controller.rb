# frozen_string_literal: true

class DisciplinesController < ApplicationController
  before_action :set_discipline, only: %i[show update destroy]

  # GET /disciplines
  # GET /disciplines.json
  def index
    @disciplines = Discipline.all
  end

  # GET /disciplines/1
  # GET /disciplines/1.json
  def show; end

  # POST /disciplines
  # POST /disciplines.json
  def create
    @discipline = Discipline.new(discipline_params)

    if @discipline.save
      render :show, status: :created, location: @discipline
    else
      render json: @discipline.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /disciplines/1
  # PATCH/PUT /disciplines/1.json
  def update
    if @discipline.update(discipline_params)
      render :show, status: :ok, location: @discipline
    else
      render json: @discipline.errors, status: :unprocessable_entity
    end
  end

  # DELETE /disciplines/1
  # DELETE /disciplines/1.json
  def destroy
    @discipline.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_discipline
    @discipline = Discipline.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def discipline_params
    params.require(:discipline).permit(:name)
  end
end
