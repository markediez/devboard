class CreateDevboardDeveloperAccountForDevelopers < ActiveRecord::Migration[5.0]
  def change
    Developer.all.each do |d|
      # Create a devboard developer account for developers without one
      if DeveloperAccount.where(:developer_id => d.id, :account_type => 'devboard').empty?
        da = DeveloperAccount.new
        da.developer = d
        da.email = d.email
        da.loginid = d.loginid
        da.name = d.name
        da.account_type = "devboard"
        da.save!
      end
    end
  end
end
