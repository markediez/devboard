class MeetingNote < ActiveRecord::Base
  belongs_to :project
  
  validates_presence_of :title, :body
  
  def to_param
    [id, title.parameterize].join("-")
  end
end
