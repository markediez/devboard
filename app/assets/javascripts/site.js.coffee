# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->
  # Set up event listeners
  $(".task input:checkbox").on "click", (e) ->
    toggleTaskStatus(this)

  # Set up drag and drop for tasks
  $(".assignment, .unassigned-task-container").sortable(
    connectWith: ".connected-sortable"
    start: (e, ui) ->
      # Set overflow to visible for the dragged task to be seen
      $(".unassigned-task-container").css("overflow-y", "visible")
    stop: (e, ui) ->
      # Reset after dragging 
      $(".unassigned-task-container").css("overflow-y", "auto")
  ).disableSelection()


  rangeSlider = ->
    slider = $('.range-slider')
    range = $('.range-slider-range')
    value = $('.range-slider-value')
    slider.each ->
      value.each ->
        `var value`
        value = $(this).prev().attr('value')
        $(this).html value
        return
      range.on 'input', ->
        $(this).next(value).html @value
        return
      return
    return

  rangeSlider()
  return

# el = checkbox of a task
toggleView = (el) ->
  task = $(el).closest(".task")
  if $(el).is(":checked")
    task.removeClass("assigned-task")
    task.addClass("finished-task");
  else
    task.removeClass("finished-task")
    task.addClass("assigned-task")

# Opens / closes tasks
# el = checkbox of a task
toggleTaskStatus = (el) ->
  taskId = $(el).closest(".task").data("task-id")
  timestamp = if $(el).is(":checked") then getTimeNow() else null

  $.ajax
    url: "/tasks/#{taskId}.json"
    type: "put"
    data:
      task:
        completed_at: timestamp
    success: (data, status, xhr) ->
      debugger
      toggleView(el)
    error: (data, status, xhr) ->
      console.log ":("

# Toggles the task between finished and unfinished
# @param el - The checkbox toggled
this.toggleTaskCompleted = (el) ->
  container = $(el).closest(".task")

  # Gray out if the task is finished
  if( $("input", container).is(':checked') )
    container.removeClass("ipa-task");
    container.addClass("finished-task");
  else
    container.removeClass("finished-task");
    container.addClass("ipa-task");
