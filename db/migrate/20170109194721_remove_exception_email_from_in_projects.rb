class RemoveExceptionEmailFromInProjects < ActiveRecord::Migration[5.0]
  def change
    Project.all.each do |project|
      from = ExceptionFromEmail.new
      from.email = project.exception_email_from
      from.project_id = project.id
      from.save
    end

    remove_column :projects, :exception_email_from
  end
end
