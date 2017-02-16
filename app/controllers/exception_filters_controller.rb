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

    respond_to do |format|
      if @exception_filter.save
        format.html { redirect_to @exception_filter, notice: 'Meeting note was successfully created.' }
        format.json { render action: 'show', status: :created, location: @exception_filter }
      else
        format.html { render action: 'new' }
        format.json { render json: @exception_filter.errors, status: :unprocessable_entity }
      end
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_exception_filter
      @exception_filter = ExceptionFilter.find(params[:id])
    end

    def exception_filter_params
      params.require(:exception_filter).permit(:concern, :pattern, :kind, :value)
    end
end
