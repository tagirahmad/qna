$(document).on('turbolinks:load', function(){
  $('.question').on('click', '.edit-question', function(e) {
      e.preventDefault();
      $(this).hide();
      var questionId = $(this).data('questionId');
      $('form#edit-question-' + questionId).removeClass('hidden');
  });
});

