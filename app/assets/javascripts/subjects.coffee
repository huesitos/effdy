# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'ready page:load', ->
  $('.colorpicker').minicolors theme: 'bootstrap', control: 'wheel'

  $('#subject_color, #subject_code').on 'change keyup', ->
    subject_code = $('#subject_code')
    subject_color = $('#subject_color')
    $('#preview').text(subject_code.val())
    $('#preview').css {'background-color': subject_color.val(), 'margin-left': '80%', color: '#fff'}

  $('.subject-destroy').click ->
    console.log $(this).prev('.delete-link').attr 'href'
    confirmation = confirm('this will delete the subject with all its topics. Are you sure?')
    if confirmation
      subject_delete = $(this).closest('li')
      $.ajax({
        url: $(this).prev('.delete-link').attr 'href'
        type: 'DELETE'
        dataType: 'json'
        success: ->
          subject_delete.remove()
      })
