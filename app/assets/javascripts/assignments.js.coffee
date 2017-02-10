//= require jquery-ui/core
//= require jquery-ui/widgets/datepicker
//= require jquery-ui/widgets/droppable
//= require jquery-ui/widgets/sortable
//= require bootstrap-datepicker/core
//= require underscore

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
      toastr.success('Task status toggled.')
    error: (data, status, xhr) ->
      toastr.error('Task status not toggled.')

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

      $placeholder = $(this).find('.ui-sortable-placeholder')

      # Use .length > 0 as .prev() will always return an object, so checking for null won't work
      sortLeftBound = null
      if $placeholder.prev().length > 0
        # Use assignment to the left
        sortLeftBound = $placeholder.prev().data('sort-position')

      sortRightBound = null
      if $placeholder.next().length > 0
        # No assignment to the left, so use any value less than the lowest
        sortRightBound = $placeholder.next().data('sort-position')
      if sortRightBound == undefined
        sortRightBound = null # .new-task or .hidden-task will cause this

      if sortLeftBound? and sortRightBound?
        sortPosition = (parseFloat(sortLeftBound) + parseFloat(sortRightBound)) / 2.0
      else if sortLeftBound == null and sortRightBound?
        sortPosition = sortRightBound - 1
      else if sortLeftBound? and sortRightBound == null
        sortPosition = sortLeftBound + 1

      console.debug "sortPosition is #{sortPosition}"

      if developerId == undefined
        # Assignment is being unassigned or unassigned task is being reordered
        if assignmentId?
          console.debug "assignment is being unassigned"
          $.ajax
            url: Routes.assignment_path(assignmentId) + ".json"
            type: 'DELETE'
            success: (data, textStatus, jqXhr) ->
              toastr.success('Assignment removed.')
              $.ajax
                url: Routes.task_path(taskId) + ".json"
                type: 'PUT'
                data:
                  task:
                    id: taskId
                    sort_position: sortPosition
                success: (data, textStatus, jqXhr) ->
                  # Update sort_position
                  ui.draggable.data('sort-position', sortPosition)
                  ui.draggable.attr('data-sort-position', sortPosition)
                  # Unassign the assignmentId
                  ui.draggable.removeAttr('data-assignment-id')
                  ui.draggable.removeData('assignment-id')
                  toastr.success('Task updated.')
                error: (jqXHR, textStatus, errorThrown ) ->
                  toastr.error('Unable to update task.')
            error: (jqXHR, textStatus, errorThrown ) ->
              toastr.error('Unable to remove assignment.')
        else
          console.debug "unassigned task is being reordered"
          $.ajax
            url: Routes.task_path(taskId) + ".json"
            type: 'PUT'
            data:
              task:
                id: taskId
                sort_position: sortPosition
            success: (data, textStatus, jqXhr) ->
              # Update sort_position
              ui.draggable.data('sort-position', sortPosition)
              ui.draggable.attr('data-sort-position', sortPosition)
              toastr.success('Task updated.')
            error: (jqXHR, textStatus, errorThrown ) ->
              toastr.error('Unable to update task.')
      else
        if assignmentId == undefined
          # Assignment is being created
          console.debug "assignment is being created"
          $.ajax
            url: Routes.assignments_path() + ".json"
            type: 'POST'
            data:
              assignment:
                developer_account_id: pickDeveloperAccount(developerId, taskIsGithub)
                task_id: taskId
                sort_position: sortPosition
            success: (data, textStatus, jqXhr) ->
              # Set assignment-id
              ui.draggable.data('assignment-id', data.assignment.id)
              ui.draggable.attr('data-assignment-id', data.assignment.id)
              # Update sort_position
              ui.draggable.data('sort-position', sortPosition)
              ui.draggable.attr('data-sort-position', sortPosition)
              toastr.success('Assignment created.')
            error: (jqXHR, textStatus, errorThrown ) ->
              toastr.error('Unable to create assignment.')
        else
          # Assignment is being switched from one developer to another, or being resorted within the same developer
          console.debug "assignment is being reordered or switched to another developer"
          $.ajax
            url: Routes.assignment_path(assignmentId) + ".json"
            type: 'PUT'
            data:
              assignment:
                id: assignmentId
                developer_account_id: pickDeveloperAccount(developerId, taskIsGithub)
                task_id: taskId
                sort_position: sortPosition
            success: (data, textStatus, jqXhr) ->
              # Update sort_position
              ui.draggable.data('sort-position', sortPosition)
              ui.draggable.attr('data-sort-position', sortPosition)
              toastr.success('Assignment updated.')
            error: (jqXHR, textStatus, errorThrown ) ->
              toastr.error('Unable to update assignment.')
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

  $(".date-nav .date-picker").datepicker
    format: "DD, M d, yyyy"
    autoclose: true

  $(".date-nav .date-picker").datepicker('setDate', viewDate)
  $(".date-nav .date-picker").datepicker('update')

  $(".date-nav .date-picker").datepicker().on "changeDate", () ->
    currDate = new Date $(".date-nav .date-picker").val()
    window.location.href = window.location.origin + Routes.assignments_path() + "/" + getDateString(currDate)

  # Set up event listeners
  $(".date-nav [data-nav=tomorrow]").on "click", (e) ->
    currDate = new Date $(".date-nav .date-picker").val()
    currDate.setDate(currDate.getDate() + 1)
    $(".date-nav .date-picker").datepicker('setDate', currDate)
    $(".date-nav .date-picker").datepicker('update')

  $(".date-nav [data-nav=yesterday]").on "click", (e) ->
    currDate = new Date $(".date-nav .date-picker").val()
    currDate.setDate(currDate.getDate() - 1)
    $(".date-nav .date-picker").datepicker('setDate', currDate)
    $(".date-nav .date-picker").datepicker('update')

# Returns a YYYY-MM-DD format of a date's toLocaleDateString
# date = date object
# if date.toLocaleDateString() = "2/7/2017" then this function will return "2017-02-07"
getDateString = (date) ->
  # [0] = month, [1] = day, [2] = year
  date = date.toLocaleDateString().split("/")

  month = "0" + date[0]
  day = "0" + date[1]

  return date[2] + "-" + month.substr(month.length - 2) + "-" + day.substr(day.length - 2)
