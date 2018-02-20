# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->

  $('.vote').bind 'ajax:success', (e) ->
    answer = $.parseJSON(e.detail[2].responseText)
    $('.answer_' + answer.id + '_rating').html(answer.rating)
  .bind 'ajax:error', (e) ->
    $('.vote').html(e.detail[0])
