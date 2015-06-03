# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
# Hide HTML-rendered messages.
$(() ->
  $messages = $('.flash-message')
  $messageList = $('.flash-messages')

  $messageList.hide();

  texts = $.map($messages, (el) -> $(el).text())

  # TODO: Dispatch appropiate notification type.
  toastr.options.positionClass = 'toast-bottom-right'
  
  $.each(texts, (idx, t) -> toastr.success(t))
)
