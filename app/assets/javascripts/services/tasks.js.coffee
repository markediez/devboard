Devboard.Services.TasksService =
  _tasks: null

  # To be called before using TasksService
  initialize: () ->
    console.debug "TasksService initialize."
    this._tasks = new Devboard.Collections.Tasks();

    this.fetchAll().then( (tasks) =>
      this._tasks.add(tasks)
    )

  # Fetches the list of projects from the server
  fetchAll: () ->
    console.debug "TasksService fetchAll."
    return Q(jQuery.ajax(
      url: Routes.tasks_path() + ".json"
      type: 'GET')).then ((tasks) ->
        return tasks
    ), (xhr) ->
      # on failure
      console.debug 'Unable to TasksService.fetchAll, server returned error.'
      console.debug xhr
      return null
