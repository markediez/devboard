class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :loginid
      t.boolean :active, :default => true

      t.timestamps
    end
  end
end
