Devboard.Views.TaskFormModal = Backbone.View.extend(
  tagName: "div"
  className: "modal fade modal-container"
  id: "add_task"
  template: JST['templates/task_form_modal']
  events:
    "hidden.bs.modal" : "cleanUpModal"

  initialize: ->
    debugger
    console.debug "TaskFormModal view initialized."

  render: ->
    @$el.html @template({ model: @model })
    @

  cleanUpModal: ->
    @remove()
)
