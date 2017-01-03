# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->

  rangeSlider = ->
    slider = $('.range-slider')
    range = $('.range-slider__range')
    value = $('.range-slider__value')
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