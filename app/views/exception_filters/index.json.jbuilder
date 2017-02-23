json.array!(@exception_filters) do |filter|
  json.extract! filter, :id, :concern, :pattern, :kind, :value
  json.url exception_filter_url(filter, format: :json)
end
