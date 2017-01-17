class RenameOriginalIdToDuplicatedId < ActiveRecord::Migration[5.0]
  def change
    rename_column :exception_reports, :original_id, :duplicated_id
  end
end
