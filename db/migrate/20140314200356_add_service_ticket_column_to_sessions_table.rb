class AddServiceTicketColumnToSessionsTable < ActiveRecord::Migration
  def change
    add_column :sessions, :service_ticket, :string
  end
end
