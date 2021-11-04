import consumer from "./consumer";

consumer.subscriptions.create({ channel: "CommentsChannel", question_id: gon.question_id }, {
    connected() {
        this.perform('follow');
    },
    received(data) {
        const type = data.comment.commentable_type.toLowerCase();
        const id = data.comment.commentable_id;

        if (data.current_user_id == null || gon.current_user_id != data.current_user_id) {
            if (type === 'question') {
                // $('.question-comments-list').append(data.partial);
            } else {
                $(`.comments[answer-id=${id}]`).append(data.partial);
            }
        }

    },
})
