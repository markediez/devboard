$(document).ready ->
  # $(".cb-email").on("click", toggleRow(this));

this.toggleRow = (el) ->
  if $(el).is(":checked")
    $(el).closest(".table-row").addClass("selected-row")
  else
    $(el).closest(".table-row").removeClass("selected-row")
