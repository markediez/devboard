$(document).ready ->
  $(".notice, .notice-confirm").hide()

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
  $.ajax
    url: window.location.href + "/#{id}"
    method: "DELETE"
    success: (data, status, xhr) ->
      $('[data-exception-report-id="' + id + '"]').hide(500)
    error: (data, status, xhr) ->
      # Should send exception email?
      # Should flash?
      console.log "something went wrong"


flashMessage = (type, msg) ->
  $(".notice").fadeIn(400)
  $(".notice span").html(msg)
  setTimeout ( ->
    $(".notice").fadeOut(400)
  ), 1500

letUserSelectOriginal = ->
  $(".notice-confirm").fadeIn(400)
  $("input").attr("disabled", "true")
  $("select").attr("disabled", "true")
  $("input:not(:checked).cb-email").closest(".table-row").addClass("option-original")

  $(".table-row.option-original").on "click", (e) ->
    originalId = $(this).data("exception-report-id")

    $("input:checked.cb-email").each ->
      duplicateId = $(this).closest(".table-row").data("exception-report-id")
      console.log "#{duplicateId} ----> #{originalId}"
      $('[data-exception-report-id="' + duplicateId + '"]').fadeOut(500)
      # $.ajax
      #   url: window.location.href + "/#{duplicateId}"
      #   method: "PATCH"
      #   success: (data, status, xhr) ->
      #     $('[data-exception-report-id="' + duplicateId + '"]').fadeOut(500)

    revert()

revert = ->
  $(".notice-confirm").fadeOut(400)
  $("input").removeAttr("disabled")
  $("select").removeAttr("disabled")
  $(".table-row.option-original").off "click"
  $(".table-row.option-original").removeClass("option-original")
