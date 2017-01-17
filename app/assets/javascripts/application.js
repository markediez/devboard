//= require jquery
//= require jquery-ui
//= require bootstrap
//= require Chart
//= require routes
//= require_tree .

$(document).ready(function() {
  $.ajaxSetup({
    headers: { 'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content') }
  });
});

/**
 * Renders new fields (e.g. more repositories or more assignees)
 * @param association - model created
 * @param content - html to render
 */
function rails_nested_form_add_fields(association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g")
  $(content.replace(regexp, new_id)).insertBefore(".add-field");
  return false;
}

/**
 * Removes a field (e.g. a repository field or assignee field)
 * closest to the button / link clicked
 * @param link - the button / link clicked by user
 */
function rails_nested_form_remove_fields(link) {
  $(link).prev('input[type=hidden]').val("true");
  $(link).closest('.fields').hide();
  return false;
}
