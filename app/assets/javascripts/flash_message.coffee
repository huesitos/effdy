# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
# Hide HTML-rendered messages.
$(() ->
  $messages = $('.flash-message')
  $messageList = $('.flash-messages')

  $messageList.hide();

  texts = $.map(
    $messages, (el) ->
      $el = $(el)
      regExp = /flash-message-(\w+)/gi

      # type is the 1st matching group.
      type = regExp.exec($el.attr 'class')[1] || 'info'

      return {
        type: type,
        text: $el.text()
      }
  )

  toastr.options.positionClass = 'toast-bottom-left'

  $.each(texts, (idx, t) -> toastr[t.type](t.text))
)
