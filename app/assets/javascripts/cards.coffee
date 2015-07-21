# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'page:ready page:change', ->
  $('#continue').click ->
    card_front = $('#card_front')
    card_back = $('#card_back')
    $.ajax({
      url: $('#new_card').attr 'action'
      type: 'POST'
      dataType: 'json'
      data: {card: { front: card_front.val(), back: card_back.val() }}
      success: ->
        card_front.val ''
        card_back.val ''
    })

  if $('body').hasClass 'topics'
    $card_delete = null
    
    $('.destroy').click ->
      $card_delete = $(this).closest('.card-container')

    $('.confirm').confirm({
        confirm: -> 
          console.log($card_delete)
          $.ajax({
            url: $($card_delete).find('.destroy-card').attr 'href'
            type: 'DELETE'
            dataType: 'json'
            success: ->
              $card_delete.remove()
          })
      })
