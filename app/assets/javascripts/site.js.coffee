# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->

  rangeSlider = ->
    slider = $('.range-slider')
    range = $('.range-slider-range')
    value = $('.range-slider-value')
    slider.each ->
      value.each ->
        `var value`
        value = $(this).prev().attr('value')
        $(this).html value
        return
      range.on 'input', ->
        $(this).next(value).html @value
        return
      return
    return

  rangeSlider()
  return

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
