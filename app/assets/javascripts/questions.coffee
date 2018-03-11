# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


vote_question = ->
  $('.vote_question').bind 'ajax:success', (e) ->
    question = $.parseJSON(e.detail[2].responseText).question
    $('.question_rating').html(question.rating)
    $(this).hide()
    $(this).next().children().first().html("Cancel vote").show()
    $(this).next().children().first().attr("href", "/questions/#{question.id}/cancel_vote")
  .bind 'ajax:error', (e) ->
    $('.vote_error_question').html("You have already voted!")

cancel_vote_question = ->
  $('.cancel_vote_question').bind 'ajax:success', (e) ->
    question = $.parseJSON(e.detail[2].responseText).question
    $('.question_rating').html(question.rating)
    $(this).hide()
  .bind 'ajax:error', (e) ->
    $('.vote_error_question').html("You haven't voted yet")

$ ->
  App.cable.subscriptions.create('QuestionsChannel', {
    connected: ->
      @perform 'follow'
    ,
    received: (data) ->
      $('.questions_list').prepend data
    })

$(document).ready(vote_question)
$(document).ready(cancel_vote_question)
$(document).on('turbolinks:load', vote_question)
$(document).on('turbolinks:load', cancel_vote_question)
