/**
 * Toggles the task between finished and unfinished
 * @param el - The checkbox toggled
 */
function toggleTaskCompleted(el) {
  container = $(el).closest(".assignment_section_task")

  // Gray out if the task is finished
  if( $("input", container).is(':checked') ) {
    container.removeClass("ipa-task");
    container.addClass("finished-task");
  } else {
    container.removeClass("finished-task");
    container.addClass("ipa-task");
  }
}
