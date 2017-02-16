//= require jquery
//= require bootstrap
//= require routes
//= require toastr
//= require q

//= require devboard

$(document).ready(function() {
  $.ajaxSetup({
    headers: { 'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content') }
  });

  // Configure the Toastr (plug it in, hope there's butter in the fridge, etc.)
  toastr.options = {
    "closeButton": false,
    "debug": false,
    "newestOnTop": false,
    "progressBar": false,
    "positionClass": "toast-bottom-center",
    "preventDuplicates": false,
    "onclick": null,
    "showDuration": "300",
    "hideDuration": "1000",
    "timeOut": "5000",
    "extendedTimeOut": "1000",
    "showEasing": "swing",
    "hideEasing": "linear",
    "showMethod": "fadeIn",
    "hideMethod": "fadeOut"
  }
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
