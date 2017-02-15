Devboard.Services.ProjectsService =
  _projects: null

  initialize: () ->
    console.debug "ProjectsService initialize."
    this._projects = new Devboard.Collections.Projects();

    this.fetchAll().then( (projects) =>
      this._projects.add(projects)
    )

  fetchAll: () ->
    console.debug "ProjectsService fetchAll."
    return Q(jQuery.ajax(
      url: Routes.projects_path() + ".json"
      type: 'GET')).then ((projects) ->
        return projects
    ), (xhr) ->
      # on failure
      console.debug 'Unable to ProjectsService.fetchAll, server returned error.'
      console.debug xhr
      return null
