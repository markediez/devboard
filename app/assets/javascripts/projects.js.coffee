# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.setTaskCompleted = (task_id, el) ->
  debugger
  $.ajax(
    url: "/tasks/#{task_id}.json"
    type: 'PUT'
    data:
      task:
        completed_at: if $(el).is(':checked') then (new Date().toISOString()) else null
    success: (response) ->
      console.log response
  )
