module ProjectsHelper
  def project_status_in_words(status)
    return status.to_s.gsub(/_/, ' ').capitalize
  end

  def link_to_add_fields(name, f, association)
    new_object = Repository.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render("repository_fields", :f => builder)
    end
    link_to_function(name, "add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")")
  end
end
