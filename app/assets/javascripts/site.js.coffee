# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# Global Variables

$(document).ready ->
  # Need this to detect if we drag tasks between developers / unassigned tasks
  origin = undefined

  # Set up event listeners
  $(".task input:checkbox").on "click", (e) ->
    toggleTaskStatus(this)

  # Set up drag and drop for tasks
  $(".assignment, .unassigned-task-container").sortable(
    connectWith: ".connected-sortable"
    start: (e, ui) ->
      # Set overflow to visible for the dragged task to be seen
      $(".unassigned-task-container").css("overflow-y", "visible")

      # Set origin of task
      origin = $(this.closest("[data-developer-id]")).data("developer-id")
    stop: (e, ui) ->
      # Reset after dragging
      $(".unassigned-task-container").css("overflow-y", "auto")
  ).disableSelection().droppable(
    drop: (event, ui) ->
      taskId = $(ui.draggable).data("task-id")
      destination = $(this.closest("[data-developer-id]")).data("developer-id")
      uniqueId = Date.now()

      if destination != origin
        # Assign task to a developer
        if destination != -1
          $.ajax
            url: "/tasks/#{taskId}.json"
            type: "put"
            data:
              task:
                assignments_attributes:
                  "#{uniqueId}":
                    developer_account_id: destination
                    _destroy: "false"
            success: (data, status, xhr) ->

            error: (data, status, xhr) ->
              console.log ":("
        else
          # Unassign task from developer
          $.post
            url: "/tasks/unassign"
            data:
              task:
                developer_account_id: origin
                task_id: taskId
            success: (data, status, xhr) ->
              console.log ":)"
            error: (data, status, xhr) ->
              console.log ":("
  )


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
