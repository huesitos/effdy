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
