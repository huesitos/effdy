# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'load page:ready page:change', ->
  if $('body').hasClass 'topics'
    $topic_delete = null

    $('.destroy-action').click ->
      $topic_delete = $(this).closest('.st_row')

    $('.confirm').confirm({
      confirm: -> 
        $.ajax({
          url: $($topic_delete).find('.delete-link').attr 'href'
          type: 'DELETE'
          dataType: 'json'
          success: ->
            $topic_delete.remove()
            $topic_delete = null
        })
    })

  $('.front').addClass('active')

  $('.front').click ->
    $(this).toggleClass('active')
    $(this).parent().children('.back').toggleClass('active')

  $('.back').click ->
    $(this).toggleClass('active')
    $(this).parent().children('.front').toggleClass('active')
