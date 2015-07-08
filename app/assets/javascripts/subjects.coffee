# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'ready page:load', ->
  $('.colorpicker').minicolors theme: 'bootstrap', control: 'wheel'

  $('#subject_color, #subject_code').on 'change keyup', ->
    subject_code = $('#subject_code')
    subject_color = $('#subject_color')
    $('.label').text(subject_code.val())
    $('.label').css {'background-color': subject_color.val(), color: '#fff', 'margin': '15px 0'}

  $('.subject-destroy').click ->
    console.log $(this).prev('.delete-link').attr 'href'
    confirmation = confirm('This will delete the subject. Are you sure?')
    if confirmation
      subject_delete = $(this).closest('.row')
      $.ajax({
        url: $(this).prev('.delete-link').attr 'href'
        type: 'DELETE'
        dataType: 'json'
        success: ->
          subject_delete.remove()
      })

  $('.subject-destroy-all').click ->
    $link = $(this).closest('li').children('.options').children('.delete-all').attr 'href'
    confirmation = confirm('This will delete the subject with all its topics. Are you sure?')
    if confirmation
      subject_delete = $(this).closest('li')
      $.ajax({
        url: $link
        type: 'DELETE'
        dataType: 'json'
        success: ->
          subject_delete.remove()
      })