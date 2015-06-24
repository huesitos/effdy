# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'load page:ready page:change', ->
  $('.destroy-action').click ->
    topic_delte = $(this).closest('li')
    console.log $(this).prev('.delete-link').attr 'href'
    $.ajax({
      url: $(this).prev('.delete-link').attr 'href'
      type: 'DELETE'
      dataType: 'json'
      success: ->
        topic_delte.remove()
    })
