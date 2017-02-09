$(document).ready ->
  setupDatePicker()
  setupDragAndDropForAssignments()

  $(".task input:checkbox").on "click", (e) ->
    toggleTaskStatus(this)

  setupRangeSlider()

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
  timestamp = if $(el).is(":checked") then getFormattedDate() else null

  $.ajax
    url: "/tasks/#{taskId}.json"
    type: "PUT"
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
      originalDeveloperId = ui.draggable.parent().data('developer-id')
      developerId = $(this).data('developer-id')
      taskId = $(ui.draggable).data("task-id")
      taskIsGithub = $(ui.draggable).data("task-github")
      assignmentId = $(ui.draggable).data("assignment-id")

      # New sort position (Warning: jQuery UI DOM nonsense ahead!)
      # Our new sort position is the location of the 'placeholder' (whitespace) element, except for a few considerations ...
      sortPosition = $(this).find('.ui-sortable-placeholder').index()

      # ... like if the developer didn't change, the draggable item is attached to the row, so our math is off by one
      if originalDeveloperId == developerId
        sortPosition = sortPosition - 1

        # ... except if we're dropping at the leftmost position, we'll end up with -1, so fix it.
        sortPosition = 0 if sortPosition == -1

      # sortPosition starts at 0 from the left for developers and 0 from the top for unassigned
      # developerId will be -1 if it was dropped in the unassigned area
      console.log "TODO: update assignment (#{assignmentId}) to be developer_id #{developerId} and position #{sortPosition} (task #{taskId})"

      if developerId == -1
        # Assignment is being unassigned entirely
        $.ajax
          url: Routes.assignment_path(assignmentId)
          type: 'DELETE'
          success: (data, textStatus, jqXhr) ->
            console.log "successfully deleted assignment"
          error: (jqXHR, textStatus, errorThrown ) ->
            console.error "unable to delete assignment due to error"
      else
        # Assignment is being switched from one developer to another, or being resorted within the same developer
        $.ajax
          url: Routes.assignment_path(assignmentId)
          type: 'PUT'
          data:
            assignment:
              id: assignmentId
              developer_account_id: pickDeveloperAccount(developerId, taskIsGithub)
              task_id: taskId
              sort_position: sortPosition
          success: (data, textStatus, jqXhr) ->
            console.log "successfully deleted assignment"
          error: (jqXHR, textStatus, errorThrown ) ->
            console.error "unable to delete assignment due to error"
  )

# Returns the developer_account_id associated with developerId. If useGithub is true
# it will return the github developer_account if available, else null. If useGithub is
# false, it will prefer the devboard-type developer_account.
pickDeveloperAccount = (developerId, useGithub) ->
  if window.devboard == null
    console.error("Cannot pickDeveloperAccount(), window.devboard does not exist.")
    return null

  # Fetch all developer_accounts for developerId
  developer = _.find(window.devboard.developers, (developer) ->
    developer.id == developerId
  )

  if developer == undefined
    console.error("Cannot pickDeveloperAccount(), no developer with developerId #{developerId}.")
    return null

  accountType = if useGithub then 'github' else 'devboard'

  account = _.find(developer.accounts, (account) ->
    return account.type == accountType
  )

  if account == undefined
    console.error("Cannot pickDeveloperAccount(), could not find account with type '#{accountType}'.")
    return null

  return account.id

setupDatePicker = () ->
  # Get time in seconds
  viewDate = new Date(window.devboard.assignmentsWidget.time_to_view)

  $(".date-picker").datepicker
    format: "DD, M d, yyyy"
    autoclose: true

  $(".assignments-widget .date-picker").datepicker('setDate', viewDate)
  $(".assignments-widget .date-picker").datepicker('update')

  $(".assignments-widget .date-picker").datepicker().on "changeDate", () ->
    currDate = new Date $(".date-picker").val()
    window.location.href = window.location.origin + window.location.pathname + "?date=" + getDateString(currDate)

  # Set up event listeners
  $(".assignments-widget [data-nav=tomorrow]").on "click", (e) ->
    currDate = new Date $(".assignments-widget .date-picker").val()
    currDate.setDate(currDate.getDate() + 1)
    $(".assignments-widget .date-picker").datepicker('setDate', currDate)
    $(".assignments-widget .date-picker").datepicker('update')

  $(".assignments-widget [data-nav=yesterday]").on "click", (e) ->
    currDate = new Date $(".assignments-widget .date-picker").val()
    currDate.setDate(currDate.getDate() - 1)
    $(".assignments-widget .date-picker").datepicker('setDate', currDate)
    $(".assignments-widget .date-picker").datepicker('update')

# Returns a YYYY-MM-DD format of a date's toLocaleDateString
# date = date object
# if date.toLocaleDateString() = "2/7/2017" then this function will return "2017-02-07"
getDateString = (date) ->
  # [0] = month, [1] = day, [2] = year
  date = date.toLocaleDateString().split("/")

  month = "0" + date[0]
  day = "0" + date[1]

  return date[2] + "-" + month.substr(month.length - 2) + "-" + day.substr(day.length - 2)
