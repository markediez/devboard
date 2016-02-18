class CreateApiKeyUsers < ActiveRecord::Migration
  def change
    create_table :api_key_users do |t|
      t.string :name
      t.string :secret

      t.timestamps null: false
    end
  end
end
