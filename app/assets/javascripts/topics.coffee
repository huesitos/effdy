# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'load page:ready page:change', ->
  $('.front').addClass('active')

  $('.destroy-action').click ->
    confirmation = confirm('Are you sure?')
    if confirmation
      topic_delte = $(this).closest('li')
      delete_from_left_menu = $("##{ $(this).prev('.delete-link').attr('href').substring(8) }")
      $.ajax({
        url: $(this).prev('.delete-link').attr 'href'
        type: 'DELETE'
        dataType: 'json'
        success: ->
          topic_delte.remove()
          #removes the topic from the topic menu
          delete_from_left_menu.remove()
      })

  $('.side').click ->
    $side = $('.active')
    if $side.hasClass('front')
      $(this).children('.front').toggleClass('active')
      $(this).children('.back').toggleClass('active')
    else
      $(this).children('.back').toggleClass('active')
      $(this).children('.front').toggleClass('active')
