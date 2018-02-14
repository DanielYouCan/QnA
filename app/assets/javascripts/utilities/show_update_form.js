$(document).on('turbolinks:load', function() {
  $(document).on('click', ".edit-answer-link", function(e) {
    e.preventDefault();
    $(this).hide();
    var answer_id = $(this).data('answerId')
    console.log(answer_id)
    $('form#edit_answer_' + answer_id).show()
  })
})
