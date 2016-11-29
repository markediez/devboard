module TasksHelper
  def gh_available
    current_user.developer and not current_user.developer.gh_personal_token.blank? and not current_user.developer.gh_username.blank?
  end

  def link_to_add_assignments(name, f, association)
    new_object = Assignment.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render("assignment_fields", :f => builder)
    end

    link_to name, "#", onclick: "return add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\"); ", class: "add-field"
  end
end
