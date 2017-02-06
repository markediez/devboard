class SetAssignedAtIfNeeded < ActiveRecord::Migration[5.0]
  def up
    Assignment.all.each do |a|
      if a.assigned_at == nil
        a.assigned_at = a.created_at
        a.save!
      end
    end
  end
end
