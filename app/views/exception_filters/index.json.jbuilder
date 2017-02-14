json.array!(@exception_filters) do |ef|
  json.extract! ef, :id, :concern, :pattern, :kind, :value
  json.url ef_url(ef, format: :json)
end
