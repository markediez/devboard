class CreateExceptionReports < ActiveRecord::Migration[5.0]
  def change
    create_table :exception_reports do |t|
      t.integer :project_id, :null => true
      t.string :subject, :null => false
      t.text :body, :null => false
      t.integer :gh_issue_id, :null => true
      t.boolean :duplicate, :null => true

      t.timestamps
    end
  end
end
