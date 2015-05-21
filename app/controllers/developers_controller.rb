class DevelopersController < ApplicationController
  load_and_authorize_resource
  before_action :set_developer, only: [:show, :edit, :update, :destroy]

  # GET /developers
  # GET /developers.json
  def index
    @developers = Developer.all
  end

  # GET /developers/1
  # GET /developers/1.json
  def show
    # Duration is in weeks for developer#show (days for site#overview)

    # TODO: Calculate "commits per week day" and display as bar chart

    if params[:duration] and [12, 24, 48, 96].include?(params[:duration].to_i)
      @duration = params[:duration].to_i
    else
      # Default
      @duration = 24
    end

    @commits = Commit.where(developer_account_id: @developer.accounts.map{ |a| a.id }).where('committed_at >= :date', date: Time.now - @duration.weeks).order(committed_at: :desc)

    # Set up data for the last 12 weeks (3 months) of commits (for Chart.js)
    @recent_commits_graph = {}
    @recent_lines_graph = {}

    # Fill the graph data in with zeroes in case there are no commits that
    # week. We do not want to handle gaps in data in Chart.js
    for i in 0..@duration
      @recent_commits_graph[(Time.now - i.week).strftime("%Y%U").to_i] = 0
      @recent_lines_graph[(Time.now - i.week).strftime("%Y%U").to_i] = 0
    end

    @recent_commits_by_project = {}
    @recent_lines_by_project = {}

    # Calculate the developer's average commits per week
    @commits.each do |commit|
      # strftime("%U") can return week '00' if the date falls in the previous year,
      # which is not supported by Date.commercial() (*sigh*), so we round those dates up.
      idx = commit.committed_at.strftime("%Y%U").to_i
      idx = (commit.committed_at.strftime("%Y") + "01").to_i if(idx.to_s[4..-1] == "00")
      @recent_commits_graph[idx] += 1
      @recent_lines_graph[idx] += commit.total

      if commit.project
        @recent_commits_by_project[commit.project.name] = @recent_commits_by_project[commit.project.name].to_i + 1
        @recent_lines_by_project[commit.project.name] = @recent_lines_by_project[commit.project.name].to_i + commit.total
      end
    end

    @recent_commits_graph = @recent_commits_graph.sort_by { |timestamp, commits| timestamp }
    @recent_lines_graph = @recent_lines_graph.sort_by { |timestamp, lines| timestamp }
    @recent_commits_by_project = @recent_commits_by_project.sort_by { |name, commits| -1 * commits }
    @recent_lines_by_project = @recent_lines_by_project.sort_by { |name, lines| -1 * lines }
    @total_commit_count = @commits.count
  end

  # GET /developers/new
  def new
    @developer = Developer.new
  end

  # GET /developers/1/edit
  def edit
  end

  # POST /developers
  # POST /developers.json
  def create
    @developer = Developer.new(developer_params)

    respond_to do |format|
      if @developer.save

        ActivityLog.create!({developer_id: current_user.developer_id, activity_type: :created })

        format.html { redirect_to @developer, notice: 'Developer was successfully created.' }
        format.json { render action: 'show', status: :created, location: @developer }
      else
        format.html { render action: 'new' }
        format.json { render json: @developer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /developers/1
  # PATCH/PUT /developers/1.json
  def update
    respond_to do |format|
      if @developer.update(developer_params)
        format.html { redirect_to @developer, notice: 'Developer was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @developer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /developers/1
  # DELETE /developers/1.json
  def destroy
    @developer.destroy
    respond_to do |format|
      format.html { redirect_to developers_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_developer
      @developer = Developer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def developer_params
      params.require(:developer).permit(:name, :loginid, :email, :avatar, :gh_personal_token, :gh_username)
    end
end
