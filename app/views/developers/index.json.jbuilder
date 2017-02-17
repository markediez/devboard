json.array!(@developers) do |developer|
  json.extract! developer, :id, :name, :loginid, :email
  json.accounts developer.accounts do |account|
    json.extract! account, :id, :developer_id, :account_type
  end
end
