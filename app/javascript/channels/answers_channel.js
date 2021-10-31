import consumer from "./consumer";

consumer.subscriptions.create({ channel: "AnswersChannel", question_id: gon.question_id }, {
  connected() {
    this.perform('follow');
  },
  received(data) {
    if (data.current_user_id == null || gon.current_user_id != data.current_user_id) {
      $('.other-answers').append(data.partial);
    }
  },
})
