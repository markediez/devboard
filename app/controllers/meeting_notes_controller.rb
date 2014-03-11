class MeetingNotesController < ApplicationController
  before_action :set_meeting_note, only: [:show, :edit, :update, :destroy]

  # GET /meeting_notes
  # GET /meeting_notes.json
  def index
    @meeting_notes = MeetingNote.all
  end

  # GET /meeting_notes/1
  # GET /meeting_notes/1.json
  def show
  end

  # GET /meeting_notes/new
  def new
    @meeting_note = MeetingNote.new
  end

  # GET /meeting_notes/1/edit
  def edit
  end

  # POST /meeting_notes
  # POST /meeting_notes.json
  def create
    @meeting_note = MeetingNote.new(meeting_note_params)

    respond_to do |format|
      if @meeting_note.save
        ActivityLog.create!({developer_id: current_user.developer_id, project_id: @meeting_note.project_id, meeting_note_id: @meeting_note.id, activity_type: :created })
        
        format.html { redirect_to @meeting_note, notice: 'Meeting note was successfully created.' }
        format.json { render action: 'show', status: :created, location: @meeting_note }
      else
        format.html { render action: 'new' }
        format.json { render json: @meeting_note.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /meeting_notes/1
  # PATCH/PUT /meeting_notes/1.json
  def update
    respond_to do |format|
      if @meeting_note.update(meeting_note_params)
        ActivityLog.create!({developer_id: current_user.developer_id, project_id: @meeting_note.project_id, meeting_note_id: @meeting_note.id, activity_type: :edited })
        
        format.html { redirect_to @meeting_note, notice: 'Meeting note was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @meeting_note.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /meeting_notes/1
  # DELETE /meeting_notes/1.json
  def destroy
    @meeting_note.destroy
    
    ActivityLog.create!({developer_id: current_user.developer_id, project_id: @meeting_note.project_id, meeting_note_id: @meeting_note.id, activity_type: :deleted })
    
    respond_to do |format|
      format.html { redirect_to meeting_notes_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_meeting_note
      @meeting_note = MeetingNote.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def meeting_note_params
      params.require(:meeting_note).permit(:title, :body, :project_id)
    end
end
