class ExceptionFiltersController < ApplicationController
  before_action :set_exception_filter, only: [:show, :edit, :update, :destroy]

  # GET /exception_filters
  # GET /exception_filters.json
  def index
    @exception_filters = ExceptionFilter.all
  end

  # GET /exception_filters/new
  def new
    @exception_filter = ExceptionFilter.new
  end

  # POST /exception_filter
  # POST /exception_filter.json
  def create
    @exception_filter = ExceptionFilter.new(exception_filter_params)
    @exception_filter.save
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_exception_filter
      @exception_filter = ExceptionFilter.find(params[:id])
    end

    def exception_filter_params
      params.require(:exception_filter).permit(:concern, :pattern, :kind, :value);
    end
end
