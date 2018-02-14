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
})
