json.array!(@meeting_notes) do |meeting_note|
  json.extract! meeting_note, :id, :title, :body, :project_id
  json.url meeting_note_url(meeting_note, format: :json)
end
