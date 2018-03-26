$(document).on('turbolinks:load', function() {
  $(document).on('click', ".edit-answer-link", function(e) {
    e.preventDefault();
    $(this).hide();
    var answer_id = $(this).data('answerId')
    $('.hide-answer_' + answer_id + '-form').show()
    $('form#edit_answer_' + answer_id).show()
  })

  $(document).on('click', ".edit-question-link", function(e) {
    e.preventDefault();
    $(this).hide();
    $('form.edit_question').show()
    $(".hide-question-link").show()
  })

  $(document).on('click', ".hide-answer-link", function(e) {
    e.preventDefault();
    var answer_id = $(this).data('answerId')
    $(this).hide();
    $('form#edit_answer_' + answer_id).hide()
    $('.edit-answer_' + answer_id + '-link').show()
  })

  $(document).on('click', ".hide-comment-link", function(e) {
    e.preventDefault();
    var comment_id = $(this).data('commentId')
    $(this).hide();
    $('form#edit_comment_' + comment_id).hide()
    $('.edit-comment_' + comment_id + '-link').show()
  })

  $(document).on('click', ".hide-question-link", function(e) {
    e.preventDefault();
    $(this).hide();
    $('form.edit_question').hide()
    $(".edit-question-link").show()
  })

  $(document).on('click', ".add-comment-link", function(e) {
    e.preventDefault();
    $(this).hide();
    var resource_id = $(this).data('resourceId')
    var resource_type = $(this).data('resourceType');
    $('form#new_comment_' + resource_type + '_' + resource_id).show()
    $('.hide-comment-form_' + resource_type + '_' + resource_id).show()
  })

  $(document).on('click', ".hide-add-comment-link", function(e) {
    e.preventDefault();
    var resource_id = $(this).data('resourceId')
    var resource_type = $(this).data('resourceType');
    $(this).hide();
    $('form#new_comment_' + resource_type + '_' + resource_id).hide()
    $('.add-comment-link_' + resource_type + '_' + resource_id).show()
  })

  $(document).on('click', ".edit-comment-link", function(e) {
    e.preventDefault();
    $(this).hide();
    var comment_id = $(this).data('commentId')
    $('.hide-comment_' + comment_id + '-form').show()
    $('form#edit_comment_' + comment_id).show()
  })
})
