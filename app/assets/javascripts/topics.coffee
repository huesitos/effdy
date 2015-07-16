# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'load page:ready page:change', ->
  $('.confirm').confirm({
    confirm: -> 
      topic_delte = $('#topics-list').find('.delete')
      $.ajax({
        url: $(topic_delte).find('.delete-link').attr 'href'
        type: 'DELETE'
        dataType: 'json'
        success: ->
          topic_delte.remove()
          #removes the topic from the topic menu
          delete_from_left_menu.remove()
      })
    cancel: ->
      topic_delte = $('#topics-list').find('.delete')
      topic_delte.toggleClass('delete')
  })

  $('.destroy-action').click ->
    topic_delte = $(this).closest('.st_row')
    topic_delte.toggleClass('delete')

  $('.front').addClass('active')

  $('.front').click ->
    $(this).toggleClass('active')
    $(this).parent().children('.back').toggleClass('active')

  $('.back').click ->
    $(this).toggleClass('active')
    $(this).parent().children('.front').toggleClass('active')
