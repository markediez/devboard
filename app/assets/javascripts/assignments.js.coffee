$(document).ready ->
  setupDatePicker()
  setupDragAndDropForAssignments()

  $(".task input:checkbox").on "click", (e) ->
    toggleTaskStatus(this)

  setupRangeSlider()

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
this.setupRangeSlider = ->
  range = $('.range-slider-range')
  value = $('.range-slider-value')

  $('.range-slider').each ->
    value.each ->
      `var value`
      value = $(this).prev().attr('value')
      $(this).html value
    range.on 'input', ->
      $(this).next(value).html @value

setupDragAndDropForAssignments = () ->
  $el = $(".assignments-row, .unassigned-task-container")

  $el.disableSelection()

  $el.sortable(
    items: ".assigned-task, .hidden-task"
    connectWith: ".connected-sortable"
    
    start: (e, ui) ->
      # Set overflow to visible for the dragged task to be seen
      $(".unassigned-task-container").css("overflow-y", "visible")

    stop: (e, ui) ->
      # Reset after dragging
      $(".unassigned-task-container").css("overflow-y", "auto")
  )
  
  $el.droppable(
    # droppable() lets us know if a task was moved from one developer to another, one to/from
    # the unassigned area. If it is dropped in a developer that already had it, we ignore this event as
    # it is merely a sort, which is handled in the .sortable() callbacks.
    drop: (event, ui) ->
      taskOriginalDeveloperId = ui.draggable.parent().data('developer-id')
      dropAreaDeveloperId = $(this).data('developer-id')

      # New sort position (Warning: jQuery UI DOM nonsense ahead!)
      # Our new sort position is the location of the 'placeholder' (whitespace) element, except for a few considerations ...
      newSortPosition = $(this).find('.ui-sortable-placeholder').index()

      # ... like if the developer didn't change, the draggable item is attached to the row, so our math is off by one
      if taskOriginalDeveloperId == dropAreaDeveloperId
        newSortPosition = newSortPosition - 1

        # ... except if we're dropping at the leftmost position, we'll end up with -1, so fix it.
        if(newSortPosition == -1)
          newSortPosition = 0

      console.log "TODO: update assignment to be developer_id #{dropAreaDeveloperId} and position #{newSortPosition}"

      # taskId = $(ui.draggable).data("task-id")
  )

setupDatePicker = () ->
  # Get time in seconds
  viewDate = window.location.search.substr(1).split("=")[1]

  $(".date-picker").datepicker
    format: "DD, M d, yyyy"
    autoclose: true

  # Set default value
  if viewDate
    viewDate = new Date viewDate.split("-").join("/")
  else
    viewDate = new Date

  $(".date-picker").datepicker('setDate', viewDate)
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

# Returns a YYYY-MM-DD format of a date's toLocaleDateString
# date = date object
# if date.toLocaleDateString() = "2/7/2017" then this function will return "2017-02-07"
getDateString = (date) ->
  # [0] = month, [1] = day, [2] = year
  date = date.toLocaleDateString().split("/")
  
  month = "0" + date[0]
  day = "0" + date[1]

  return date[2] + "-" + month.substr(month.length - 2) + "-" + day.substr(day.length - 2)
