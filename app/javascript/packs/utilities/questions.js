$(document).on('turbolinks:load', function () {
    const question = $('.question');

    question.on('click', '.edit-question', function (e) {
        e.preventDefault();
        $(this).hide();

        const questionId = $(this).data('questionId');
        
        $(`form#edit-question-${questionId}`).removeClass('hidden');
    });

    question.on('click', '.add-comment-question', function (e) {
        e.preventDefault();
        $(this).hide();

        const questionId = $(this).data('questionId');
        const questionForm = $(`form#comment-question-${questionId}`);

        questionForm.removeClass('hidden');
        questionForm.on('ajax:error', function (e) {
            const errors = e.detail[0];
            const errors_container = $('.flash');
            errors_container.append(errors);
        })
    });
});

