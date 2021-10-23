$(document).on('turbolinks:load',() => {
    $('.vote-btn').on('ajax:success', (e) => {
        const [vote] = e.detail;
        console.log(e.detail, '!!!!')
        $(`.vote-score[data-vote-id=${vote.id}]`).html(`<p>${vote.score}</p>`);
    })
      .on('ajax:error', function(e) {
          const [errors] = e.detail;
          const errors_container = $('.flash');

          errors_container.contents().remove()

          $.each(errors, function(_, value) {
              errors_container.append(value)
          })
      })
})
