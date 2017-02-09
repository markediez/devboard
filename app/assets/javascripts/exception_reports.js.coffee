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
  debugger
  $.post
    url: "/exception_reports/#{id}"
    method: "DELETE"
    success: (data, status, xhr) ->
      $('[data-exception-report-id="' + id + '"]').hide(500)
    error: (data, status, xhr) ->
      # Should send exception email?
      # Should flash?
      console.log "something went wrong"


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
        error: (data, status, xhr) ->
          console.log ":("

    revert()

# Reverts the page back to its original state
revert = ->
  $(".exceptions-notice-confirm").fadeOut(400)
  $("input").removeAttr("disabled")
  $("select").removeAttr("disabled")
  $(".table-row.option-original").off "click"
  $(".table-row.option-original").removeClass("option-original")
