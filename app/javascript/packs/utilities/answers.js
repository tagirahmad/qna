$(document).on('turbolinks:load', function(){
    const answers = $('.answers');

    answers.on('click', '.edit-answer-link', function(e) {
        e.preventDefault();
        $(this).hide();
        let answerId = $(this).data('answerId');
        $('form#edit-answer-' + answerId).removeClass('hidden');
    });

    answers.on('click', '.add-comment-answer', function(e) {
        e.preventDefault();
        $(this).hide();
        let answerId = $(this).data('answerId');
        $(`form#comment-answer-${answerId}`).removeClass('hidden');

        $(`#comment-answer-${answerId}`).on('ajax:error', function (e) {
            const errors = e.detail[0];
            const errors_container = $('.flash');
            errors_container.append(errors);
        })
    });
});
