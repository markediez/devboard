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
    # TODO: Calculate "commits per week day" and display as bar chart
    # TODO: Add totals, additions, and deletions to each commit

    @recent_activity = Commit.where(developer_account_id: @developer.accounts.map{ |a| a.id }).where('committed_at >= :date', date: Time.now - 1.week)

    # Set up data for the last 12 weeks (3 months) of commits (for Chart.js)
    @last_12_weeks = {}
    for i in 0..11
      @last_12_weeks[(Time.now - i.week).strftime("%Y%U").to_i] = 0
    end

    @projects = {}

    # Calculate the developer's average commits per week
    years = {}
    num_active_weeks = 0

    commits = @developer.commits
    commits.each do |commit|
      commit_year = commit.committed_at.strftime("%Y").to_i
      commit_week = commit.committed_at.strftime("%U").to_i

      years[commit_year] = [] if years[commit_year] == nil
      if years[commit_year][commit_week] == nil
        years[commit_year][commit_week] = 0
        num_active_weeks += 1
      end

      years[commit_year][commit_week] += 1

      if @last_12_weeks[commit.committed_at.strftime("%Y%U").to_i] != nil
        @last_12_weeks[commit.committed_at.strftime("%Y%U").to_i] += 1
      end

      if commit.project
        if @projects[commit.project.name] == nil
          @projects[commit.project.name] = 0
        end
        @projects[commit.project.name] += 1
      end
    end

    @last_12_weeks = @last_12_weeks.sort_by { |timestamp, commits| timestamp }

    @avg_commits_last_12_weeks = ( @last_12_weeks.map { |timestamp, commits| commits }.sum ) / 12

    @avg_commits_per_week = num_active_weeks > 0 ? commits.length / num_active_weeks : 0

    @projects = @projects.sort_by { |name, commits| -1 * commits }

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
