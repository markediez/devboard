padTwoDigits = (n) ->
  ("0" + n).slice(-2)

((tasks, $) ->
  #Private Property
  # isHot = true
  #Public Property
  #Private Method

  # addItem = (item) ->
  #   if item != undefined
  #     console.log 'Adding ' + $.trim(item)
  #   return

  # skillet.ingredient = 'Bacon Strips'
  #Public Method

  # Updates the multiple selects which comprise the due date to match value
  # represented by 'days_from_today'
  tasks.setTaskDueDate = (days_from_today) ->
    # Obtain the current value of the date selector, if any
    year = $('select#task_due_1i').val()

    if year == ""
      # Use today if no date is set
      dueDate = new Date()
    else
      month = $('select#task_due_2i').val() - 1
      day = $('select#task_due_3i').val()
      hour = $('select#task_due_4i').val()
      minute = $('select#task_due_5i').val()

      dueDate = new Date(year, month, day, hour, minute)

    # Add the specified number of days
    dueDate.setDate(dueDate.getDate() + days_from_today)

    # Set the date selector to the result
    $('select#task_due_1i').val(dueDate.getYear() + 1900)
    $('select#task_due_2i').val(dueDate.getMonth() + 1)
    $('select#task_due_3i').val(dueDate.getDate())
    $('select#task_due_4i').val(padTwoDigits(dueDate.getHours()))
    $('select#task_due_5i').val(padTwoDigits(dueDate.getMinutes()))

  # Updates the multiple selects which comprise the due date to clear their value
  tasks.clearTaskDueDate = () ->
    # Clear the date selectors
    $('select#task_due_1i').val('')
    $('select#task_due_2i').val('')
    $('select#task_due_3i').val('')
    $('select#task_due_4i').val('')
    $('select#task_due_5i').val('')

  tasks.setTaskPoints = (points) ->
    $('input#task_points').val(points)
    $("div#points input").removeClass('btn-primary')
    if points >= 1.0
      $('input#set_points_' + (points * 10)).addClass('btn-primary')
    else
      $('input#set_points_05').addClass('btn-primary')

  # Updates the multiple selects which comprise the points to clear their value
  tasks.clearTaskPoints = () ->
    $('input#task_points').val('')

) window.tasks = window.tasks or {}, jQuery


