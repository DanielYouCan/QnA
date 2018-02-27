$(document).on('turbolinks:load', ->
  return followComment() if App.comments_subscribe

  App.comments_subscribe = App.cable.subscriptions.create('CommentsChannel', {

    connected: ->
      @followComment()

    followComment: ->
      questionId = $('.answers').data('questionId')

      if questionId
        App.comments_subscribe.perform 'follow', question_id: questionId
      else
        App.comments_subscribe.perform 'unfollow'

    received: (data) ->
      commentable_type = ($.parseJSON(data['comment']).commentable_type).toLowerCase()
      commentable_id = $.parseJSON(data['comment']).commentable_id
      comments = '.' + commentable_type + '_' + commentable_id + '_comments'
      $(comments).append JST["templates/comment"](comment: $.parseJSON(data['comment']))
    }))
