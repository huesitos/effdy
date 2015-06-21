# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(window).on 'load page:load', ->
  $('.colorpicker').minicolors theme: 'bootstrap', control: 'wheel'

  $('#subject_color, #subject_code').on 'change keyup', ->
    subject_code = $('#subject_code')
    subject_color = $('#subject_color')
    $('#preview').text(subject_code.val())
    $('#preview').css {'background-color': subject_color.val(), 'margin-left': '80%', color: '#fff'}
