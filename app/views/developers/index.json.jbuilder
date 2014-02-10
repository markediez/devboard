json.array!(@developers) do |developer|
  json.extract! developer, :id, :name, :loginid, :email
  json.url developer_url(developer, format: :json)
end
