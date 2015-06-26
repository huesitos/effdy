$(document).on 'ready page:load', ->
  $('.reviewing').click ->
      $(this).toggleClass 'reviewing not-reviewing'
  $('.not-reviewing').click ->
      $(this).toggleClass 'reviewing not-reviewing'

