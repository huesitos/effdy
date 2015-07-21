# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'ready page:load', ->
  $('.colorpicker').minicolors theme: 'bootstrap', control: 'wheel'
  $('.preview-label').text($('#subject_code').val())
  $('.preview-label').css {'background-color': $('#subject_color').val(), color: '#fff', 'margin': '15px 0'}

  $('#subject_color, #subject_code').on 'change keyup', ->
    subject_code = $('#subject_code')
    subject_color = $('#subject_color')
    $('.preview-label').text(subject_code.val())
    $('.preview-label').css {'background-color': subject_color.val(), color: '#fff', 'margin': '15px 0'}

  if $('body').hasClass 'subjects'
    $subject_delete = null
    clicked = 'none'

    $('.subject-destroy').click ->
      $subject_delete = $(this).closest('.st_row')
      clicked = 'one'

    $('.subject-destroy-all').click ->
      $subject_delete = $(this).closest('.st_row')
      clicked = 'all'


    $('.subject-confirm').confirm({
      confirm: -> 
        if clicked == 'all'
          $link = $($subject_delete).find('.delete-subject-all').attr 'href'
        else
          $link = $($subject_delete).find('.delete-subject').attr 'href'

        $.ajax({
          url: $link
          type: 'DELETE'
          dataType: 'json'
          success: ->
            $subject_delete.remove()
            $subject_delete = null
        })
    })
