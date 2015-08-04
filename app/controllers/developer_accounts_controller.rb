class DeveloperAccountsController < ApplicationController
  load_and_authorize_resource
  before_action :set_developer_account, only: [:show, :edit, :update, :destroy]

  # GET /developer_accounts
  # GET /developer_accounts.json
  def index
    @developer_accounts = DeveloperAccount.all
    @developers = Developer.all
  end

  # GET /developer_accounts/1
  # GET /developer_accounts/1.json
  def show
  end

  # GET /developer_accounts/new
  def new
    @developer_account = DeveloperAccount.new
  end

  # GET /developer_accounts/1/edit
  def edit
  end

  # POST /developer_accounts
  # POST /developer_accounts.json
  def create
    @developer_account = DeveloperAccount.new(developer_account_params)

    respond_to do |format|
      if @developer_account.save

        ActivityLog.create!({developer_id: current_user.developer_id, activity_type: :created })

        format.html { redirect_to @developer_account, notice: 'Developer was successfully created.' }
        format.json { render action: 'show', status: :created, location: @developer_account }
      else
        format.html { render action: 'new' }
        format.json { render json: @developer_account.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /developer_accounts/1
  # PATCH/PUT /developer_accounts/1.json
  def update
    respond_to do |format|
      if @developer_account.update(developer_account_params)
        format.html { redirect_to developer_accounts_url, notice: 'Developer account was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { developer_accounts_url }
        format.json { render json: @developer_account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /developer_accounts/1
  # DELETE /developer_accounts/1.json
  def destroy
    @developer_account.destroy
    respond_to do |format|
      format.html { redirect_to developer_accounts_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_developer_account
      @developer_account = DeveloperAccount.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def developer_account_params
      params.require(:developer_account).permit(:developer_id, :email, :account_type)
    end
end
