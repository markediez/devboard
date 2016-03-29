class SprintsController < ApplicationController
  before_action :set_sprint, only: [:show]

  # GET /sprints
  # GET /sprints.json
  def index
    @sprints = Milestone.all
  end

  # GET /sprints/1
  # GET /sprints/1.json
  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sprint
      @sprint = Milestone.find(params[:id])
    end
end
