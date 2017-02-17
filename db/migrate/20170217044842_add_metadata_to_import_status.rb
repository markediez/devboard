class AddMetadataToImportStatus < ActiveRecord::Migration[5.0]
  def change
    add_column :import_statuses, :metadata, :string, null: true
  end
end
