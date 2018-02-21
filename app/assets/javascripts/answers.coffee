# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


vote = ->
  $('.vote').bind 'ajax:success', (e) ->
    answer = $.parseJSON(e.detail[2].responseText)
    $('.answer_' + answer.id + '_rating').html(answer.rating)
  .bind 'ajax:error', (e) ->
    id = $.parseJSON(e.detail[0])
    $('.vote_error_' + id).html("You have already voted!")

cancel_vote = ->
  $('.cancel_vote').bind 'ajax:success', (e) ->
    answer = $.parseJSON(e.detail[2].responseText)
    $('.answer_' + answer.id + '_rating').html(answer.rating)
  .bind 'ajax:error', (e) ->
    id = $.parseJSON(e.detail[0])
    $('.vote_error_' + id).html("You haven't voted yet")

$(document).ready(vote)
$(document).ready(cancel_vote)
$(document).on('turbolinks:load', vote)
$(document).on('turbolinks:load', cancel_vote)
