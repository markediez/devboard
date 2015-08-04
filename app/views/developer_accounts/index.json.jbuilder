json.array!(@developer_accounts) do |developer_account|
  json.extract! developer, :id, :account_type, :email, :developer_id
  json.url developer_url(developer_account, format: :json)
end
