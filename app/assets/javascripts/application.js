//= require jquery
//= require bootstrap
//= require routes

$(document).ready(function() {
  $.ajaxSetup({
    headers: { 'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content') }
  });
});

/**
 * Returns the date as a string in the format YYYY-MM-DD HH:MM:SS
 */
function getFormattedDate(timeInMills) {
  if(timeInMills === undefined) {
    timeInMills = Date.now();
  }
  var t = new Date(timeInMills);

  var year = t.getFullYear();
  // .slice(-2) ensures 2 digit numbers
  var month = ("0" + (t.getMonth() + 1) ).slice(-2);
  var day = ("0" + t.getDate()).slice(-2);

  var hour = ("0" + t.getHours()).slice(-2);
  var minute = ("0" + t.getMinutes()).slice(-2);
  var second = ("0" + t.getSeconds()).slice(-2);

  return year + "-" + month + "-" + day + " " + hour + ":" + minute + ":" + second;
}

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
