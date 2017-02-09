class DeleteBadAssignments < ActiveRecord::Migration[5.0]
  def change
    # The new GitHub requirement seems to have rendered a number of assignments invalid.
    Assignment.all.each do |a|
      if a.valid? == false
        a.destroy
      end
    end
  end
end
