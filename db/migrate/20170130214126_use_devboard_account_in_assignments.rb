class UseDevboardAccountInAssignments < ActiveRecord::Migration[5.0]
  def change
    Assignment.all.each do |a|
      if a.developer.present?
        a.developer_account_id = a.developer.devboard_account_id
        a.save!
      end
    end
  end
end
