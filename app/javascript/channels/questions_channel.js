import consumer from "./consumer";

consumer.subscriptions.create({ channel: "QuestionsChannel" }, {
  connected() {
    this.perform('follow')
  },
  received(data) {
    console.log(data)
    $('.questions').append(data.partial)
  },
})
