$(document).ready ->
  $(".exceptions-notice-regular, .exceptions-notice-confirm").hide()

  # Set Event Listeners
  $(".cb-email").on "click", (e) ->
    toggleRow(this)

  $("#delete").on "click", (e) ->
    reports = $("input:checked.cb-email")
    if reports.size() > 0 && confirm("Are you sure you want to delete these reports?")
      reports.each ->
        deleteMessage($(this).closest(".table-row").data("exception-report-id"))

  $("#mark-duplicate").on "click", (e) ->
    if $("input:checked.cb-email").size() > 0
      letUserSelectOriginal()
    else
      flashMessage("notice", "Nothing to mark as duplicate")

  $("#cancel").on "click", (e) ->
    revert()

  # Set up events for modal
  $("#add_exception_filter .dropdown-menu li").on "click", (e) ->
    setMenuText($("a", this).html(), this)

  $("#save-exception-filter").on "click", (e) ->
    saveFilter()

saveFilter = () ->
  concern = $("#add_exception_filter .exception-concern .dropdown-toggle .dropdown-text").html()
  pattern = $("#add_exception_filter .exception-pattern #pattern").val()
  type = $("#add_exception_filter .exception-type .dropdown-toggle .dropdown-text").html()
  project = $("#add_exception_filter .exception-project .dropdown-toggle .dropdown-text").html()

  $.post
    url: "/exception_filters.json"
    data:
      exception_filter:
        concern: concern
        pattern: pattern
        kind: type
        value: project
    success: (data, status, xhr) ->
      toastr.success('Exception filter saved.')
    error: (data, status, xhr) ->
      toastr.error('Unable to save exception filter')

# Changes the text on a dropdown button
# text = text to show
# el = li within a dropdown menu, el.parent() should be ul ".dropdown-menu"
setMenuText = (text, el) ->
  # Get the button group of the element
  group = $(el).parent().parent()

  $(".dropdown-toggle .dropdown-text", group).html(text)

# Changes the background color of a row when selected
# el = checkbox within the row, el.parent() should be row
toggleRow = (el) ->
  if $(el).is(":checked")
    $(el).closest(".table-row").addClass("selected-row")
  else
    $(el).closest(".table-row").removeClass("selected-row")


# Deletes an exception report
# id = exception report id to delete
deleteMessage = (id) ->
  $.ajax
    url: "/exception_reports/#{id}"
    type: 'DELETE'
    success: (data, status, xhr) ->
      $('[data-exception-report-id="' + id + '"]').hide(500)
      toastr.success("Reports deleted.")
    error: (data, status, xhr) ->
      # Should send exception email?
      toastr.error("Unable to delete the report(s).")


# Briefly flashes a message
flashMessage = (type, msg) ->
  $(".exceptions-notice-regular").fadeIn(400)
  $(".exceptions-notice-regular span").html(msg)
  setTimeout ( ->
    $(".exceptions-notice-regular").fadeOut(400)
  ), 1500

# Changes the table styles and event actions for specifying the original exception report
letUserSelectOriginal = ->
  $(".exceptions-notice-confirm").fadeIn(400)
  $("input").attr("disabled", "true")
  $("select").attr("disabled", "true")
  $("input:not(:checked).cb-email").closest(".table-row").addClass("option-original")

  $(".table-row.option-original").on "click", (e) ->
    originalId = $(this).data("exception-report-id")

    $("input:checked.cb-email").each ->
      duplicateId = $(this).closest(".table-row").data("exception-report-id")
      # Update exception report and remove from DOM
      $.ajax
        url: "/exception_reports/#{duplicateId}.json"
        type: "put"
        # dataType: "script"
        # contentType: 'application/json'
        data:
          exception_report:
            duplicated_id: originalId
        success: (data, status, xhr) ->
          $('[data-exception-report-id="' + duplicateId + '"]').hide()
          toastr.success("Reports sucessfully marked as duplicate.")
        error: (data, status, xhr) ->
          toastr.error("Unable to mark the report(s) as duplicate.")

    revert()

# Reverts the page back to its original state
revert = ->
  $(".exceptions-notice-confirm").fadeOut(400)
  $("input").removeAttr("disabled")
  $("select").removeAttr("disabled")
  $(".table-row.option-original").off "click"
  $(".table-row.option-original").removeClass("option-original")
