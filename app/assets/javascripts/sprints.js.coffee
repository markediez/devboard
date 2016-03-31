((sprints, $) ->
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

  sprints.setTaskPoints = (task_id, points) ->
    $.ajax
      type: 'PATCH'
      url: Routes.task_path(task_id) + '.json'
      data:
        task:
          points: points
      success: (msg) ->
        values = [1.0, 1.5, 2.0, 2.5, 3.0, 3.5, 4.0, 4.5, 5.0]
        
        # Clear existing highlights
        $('input#task_' + task_id + '_set_points_null').removeClass('btn-primary')
        $('input#task_' + task_id + '_set_points_05').removeClass('btn-primary')
        for i in values
          $('input#task_' + task_id + '_set_points_' + (i * 10)).removeClass('btn-primary')
      
        # Set the new highlight
        if points == null
          return
        else
          if points >= 1.0
            el = 'input#task_' + task_id + '_set_points_' + (points * 10)
          else
            el = 'input#task_' + task_id + '_set_points_05'
          
          $(el).addClass('btn-primary')

        return
      error: (XMLHttpRequest, textStatus, errorThrown) ->
        alert 'Could not set points.'
        return

) window.sprints = window.sprints or {}, jQuery
