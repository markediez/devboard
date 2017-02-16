Devboard.Services.DevelopersService =
  _developers: null

  # To be called before using DevelopersService
  initialize: () ->
    console.debug "DevelopersService initialize."
    this._developers = new Devboard.Collections.Developers();

    this.fetchAll().then( (developers) =>
      this._developers.add(developers)
    )

  # Fetches the list of projects from the server
  fetchAll: () ->
    console.debug "DevelopersService fetchAll."
    return Q(jQuery.ajax(
      url: Routes.developers_path() + ".json"
      type: 'GET')).then ((developers) ->
        return developers
    ), (xhr) ->
      # on failure
      console.debug 'Unable to DevelopersService.fetchAll, server returned error.'
      console.debug xhr
      return null
