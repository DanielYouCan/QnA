# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


vote = ->
  $('.vote').bind 'ajax:success', (e) ->
    answer = $.parseJSON(e.detail[2].responseText).answer
    $(".answer_#{answer.id}_rating").html(answer.rating)
    $(this).hide()
    $(this).next().children().first().html("cancel vote").show()
    $(this).next().children().first().attr("href", "/answers/#{answer.id}/cancel_vote")
  .bind 'ajax:error', (e) ->
    id = $.parseJSON(e.detail[0])
    $('.vote_error_' + id).html("You have already voted!")

cancel_vote = ->
  $('.cancel_vote').bind 'ajax:success', (e) ->
    answer = $.parseJSON(e.detail[2].responseText).answer
    $(".answer_#{answer.id}_rating").html(answer.rating)
    $(this).hide()
    $('.vote').show()
  .bind 'ajax:error', (e) ->
    id = $.parseJSON(e.detail[0])
    $('.vote_error_' + id).html("You haven't voted yet")

$(document).on('turbolinks:load', ->
  return followQuestion() if App.answers_subscribe

  App.answers_subscribe = App.cable.subscriptions.create('AnswersChannel', {
    collection: -> $('.answers')

    connected: ->
      @followQuestion()

    followQuestion: ->
      questionId = @collection().data('questionId')
      if questionId
        App.answers_subscribe.perform 'follow', question_id: questionId
      else
        App.answers_subscribe.perform 'unfollow'

    received: (data) ->
      @collection().append JST["templates/answer"](answer: $.parseJSON(data['answer']))
    }))

$(document).on('turbolinks:load', vote)
$(document).on('turbolinks:load', cancel_vote)
