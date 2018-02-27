$(document).on('turbolinks:load', function() {
  $(document).on('click', ".edit-answer-link", function(e) {
    e.preventDefault();
    $(this).hide();
    var answer_id = $(this).data('answerId')
    $('form#edit_answer_' + answer_id).show()
  })

  $(document).on('click', ".edit-question-link", function(e) {
    e.preventDefault();
    $(this).hide();
    $('form.edit_question').show()
  })

  $(document).on('click', ".add-comment-link", function(e) {
    e.preventDefault();
    $(this).hide();
    var resource_id = $(this).data('resourceId')
    var resource_type = $(this).data('resourceType');
    $('form#new_comment_' + resource_type + '_' + resource_id).show()
  })

  $(document).on('click', ".edit-comment-link", function(e) {
    e.preventDefault();
    $(this).hide();
    var comment_id = $(this).data('commentId')
    $('form#edit_comment_' + comment_id).show()
  })
})
