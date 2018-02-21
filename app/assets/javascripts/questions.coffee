# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


vote_question = ->
  $('.vote_question').bind 'ajax:success', (e) ->
    question = $.parseJSON(e.detail[2].responseText)
    $('.question_rating').html(question.rating)
  .bind 'ajax:error', (e) ->
    $('.vote_error_question').html("You have already voted!")

cancel_vote_question = ->
  $('.cancel_vote_question').bind 'ajax:success', (e) ->
    question = $.parseJSON(e.detail[2].responseText)
    $('.question_rating').html(question.rating)
  .bind 'ajax:error', (e) ->
    $('.vote_error_question').html("You haven't voted yet")

$(document).ready(vote_question)
$(document).ready(cancel_vote_question)
$(document).on('turbolinks:load', vote_question)
$(document).on('turbolinks:load', cancel_vote_question)
