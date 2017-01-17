module ApplicationHelper
  include Authentication

  def authenticated?
    not current_user.nil?
  end

  def link_to_add_fields(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end

    link_to name, "#", onclick: "return rails_nested_form_add_fields(\"#{association}\", \"#{escape_javascript(fields)}\"); ", class: "add-field"
  end

  # repo = <github-user/repository>
  def link_to_github(repo)
    return "https://github.com/" + repo
  end

  # repo = <github-user/repository>
  # issue_num = github issue number
  def link_to_github_issue(repo, issue_num )
    return "https://github.com/" + repo + "/issues/" + issue_num
  end
end
