# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

padTwoDigits = (n) ->
  ("0" + n).slice(-2)

window.setTaskDueDate = (days_from_today) ->
  # Obtain the current value of the date selector, if any
  year = $('select#task_due_1i').val()
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
