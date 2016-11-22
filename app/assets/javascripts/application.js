//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap
//= require Chart
//= require routes
//= require_tree .

Turbolinks.enableProgressBar();


function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g")
  $(content).insertBefore(".repositories .add-repository");
  return false;
}

function remove_fields(link) {
  $(link).prev('input[type=hidden]').val("true");
  $(link).closest('.fields').hide();
  return false;
}
