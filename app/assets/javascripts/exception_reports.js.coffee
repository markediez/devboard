$(document).ready ->
  $(".cb-email").on "click", (e) ->
    toggleRow(this)

  $("#delete").on "click", (e) ->
    $("input:checked.cb-email").each ->
      deleteMessage($(this).closest(".table-row").data("exception-report-id"))

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
  console.log "Deleting " + id
  $.ajax
    url: window.location.href + "/#{id}"
    method: "DELETE"
    success: (data, status, xhr) ->
      $('[data-exception-report-id="' + id + '"]').hide(500)
    error: (data, status, xhr) ->
      console.log "something went wrong"
