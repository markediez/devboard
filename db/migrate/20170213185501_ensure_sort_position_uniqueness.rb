class EnsureSortPositionUniqueness < ActiveRecord::Migration[5.0]
  # Ensures both 'Task' and 'Assignment' have unique sort_positions.
  # If a sort_position conflicts, it is merely assigned the next highest position.
  # Note: Migration assumes the only validation error will be a non-unique sort_position.
  def change
    max_pos = Task.maximum(:sort_position).to_i

    Task.all.each do |t|
      if t.valid? == false
        if t.errors[:sort_position].present?
          t.sort_position = max_pos + 1
          t.save!
          max_pos = max_pos + 1
        end
      end
    end

    max_pos = Assignment.maximum(:sort_position).to_i

    Assignment.all.each do |a|
      if a.valid? == false
        if a.errors[:sort_position].present?
          a.sort_position = max_pos + 1
          a.save!
          max_pos = max_pos + 1
        end
      end
    end
  end
end
