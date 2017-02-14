//= require jquery
//= require bootstrap
//= require routes
//= require toastr

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

    /**
     * Sidebar collapse 
     */
    $('[data-toggle=offcanvas]').click(function() {
        $('.row-offcanvas').toggleClass('active');
        $('sidebar-offcanvas').toggleClass('collapse-group');
        $('.collapse').toggleClass('in').toggleClass('hidden-xs').toggleClass('visible-xs');
        $('.navheader').toggleClass('nav-collapse');
        $('.navheader').toggleClass('col-md-11');
        $('.assignments-test').toggleClass('assigned-collapse');
        $('.date-nav').toggleClass('date-nav-collapse');

    });
});

/**
 * Returns the date as a string in the format YYYY-MM-DD HH:MM:SS
 */
function getFormattedDate(timeInMills) {
    if (timeInMills === undefined) {
        timeInMills = Date.now();
    }
    var t = new Date(timeInMills);

    var year = t.getFullYear();
    // .slice(-2) ensures 2 digit numbers
    var month = ("0" + (t.getMonth() + 1)).slice(-2);
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