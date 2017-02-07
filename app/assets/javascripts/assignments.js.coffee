# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# Global Variables

$(document).ready ->
  # Need this to detect if we drag tasks between developers / unassigned tasks
  origin = undefined

  setupDatePicker()
  setupDragAndDropForAssignments()

  $(".task input:checkbox").on "click", (e) ->
    toggleTaskStatus(this)

  return

# Assigns a task to a developer
# developerAccountId = developer to assign
# taskId = id of the task
assignTaskToDeveloper = (developerAccountId, taskId) ->
  uniqueId = Date.now()
  $.ajax
    url: "/tasks/#{taskId}.json"
    type: "put"
    data:
      task:
        assignments_attributes:
          "#{uniqueId}":
            developer_account_id: developerAccountId
            assigned_at: getTimeNow()
            _destroy: "false"
    success: (data, status, xhr) ->
      # Flash success notice?
    error: (data, status, xhr) ->
      # Flash error notice?

# Unassigns a task from a developer
# developerAccountId = developer currently assigned to task
# taskId = id of the task
unassignTaskFromDeveloper = (developerAccountId, taskId) ->
  $.post
    url: "/tasks/unassign"
    data:
      task:
        developer_account_id: developerAccountId
        task_id: taskId
    success: (data, status, xhr) ->
      # Flash success notice?
    error: (data, status, xhr) ->
      # Flash error notice?


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

# For task modal
this.rangeSlider = ->
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

setupDragAndDropForAssignments = () ->
  # reference the global origin
  origin = this

  # Set up drag and drop for tasks
  $(".assignment, .unassigned-task-container").sortable(
    items: ".assigned-task, .hidden-task"
    connectWith: ".connected-sortable"
    start: (e, ui) ->
      # Set overflow to visible for the dragged task to be seen
      $(".unassigned-task-container").css("overflow-y", "visible")

      # Set origin of task
      origin = $(this.closest("[data-developer-id]")).data("developer-id")
    stop: (e, ui) ->
      # Reset after dragging
      $(".unassigned-task-container").css("overflow-y", "auto")
    update: () ->
      taskIds = []
      tasks = $(".assigned-task, .finished-task", this)
      tasks.each () ->
        taskIds.push $(this).data("task-id")

      developerId = $($(this).closest("[data-developer-id]")).data("developer-id")
      # Save sort order
      if developerId == -1
        $.post
          url: "/tasks/sort"
          data:
            task_ids: taskIds
      else
        $.post
          url: "/assignments/sort"
          data:
            task_ids: taskIds
            developer_account_id: developerId

  ).disableSelection().droppable(
    drop: (event, ui) ->
      taskId = $(ui.draggable).data("task-id")
      destination = $(this.closest("[data-developer-id]")).data("developer-id")

      if destination != origin
        # Assign task to a developer
        if destination != -1
          if origin != -1
            unassignTaskFromDeveloper(origin, taskId)

          assignTaskToDeveloper(destination, taskId)
        else
          unassignTaskFromDeveloper(origin, taskId)
  )

setupDatePicker = () ->
  # Get time in seconds
  time = window.location.search.substr(1).split("=")[1]
  $(".date-picker").datepicker
    format: "DD, M d, yyyy"
    autoclose: true

  # Set default value
  if time
    time = new Date time.split("-").join("/")
  else
    time = new Date Date.now()

  $(".date-picker").datepicker('setDate', time)
  $(".date-picker").datepicker('update')

  $(".date-picker").datepicker().on "changeDate", () ->
    currDate = new Date $(".date-picker").val()
    window.location.href = window.location.origin + window.location.pathname + "?date=" + getDateString(currDate)

  # Set up event listeners
  $("[data-nav=tomorrow]").on "click", (e) ->
    currDate = new Date $(".date-picker").val()
    currDate.setDate(currDate.getDate() + 1)
    $(".date-picker").datepicker('setDate', currDate)
    $(".date-picker").datepicker('update')

  $("[data-nav=yesterday]").on "click", (e) ->
    currDate = new Date $(".date-picker").val()
    currDate.setDate(currDate.getDate() - 1)
    $(".date-picker").datepicker('setDate', currDate)
    $(".date-picker").datepicker('update')

getDateString = (date) ->
  # [0] = month, [1] = day, [2] = year
  date = date.toLocaleDateString().split("/")
  month = "0" + date[0]
  day = "0" + date[1]
  return date[2] + "-" + month.substr(month.length - 2) + "-" + day.substr(day.length - 2)
