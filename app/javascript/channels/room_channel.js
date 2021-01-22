import consumer from './consumer'

function formatDate(date) {
    return date.getFullYear() + "-" + ("0" + (date.getMonth() + 1)).slice(-2) + "-" + ("0" + date.getDate()).slice(-2) +
        " " + ("0" + date.getHours()).slice(-2) + ":" + ("0" + date.getMinutes()).slice(-2);

}

$(function () {
    $('[data-channel-subscribe="room"]').each(function (index, element) {
        const $element = $(element),
            room_id = $element.data('room-id'),
            messageTemplate = $('[data-role="message-template"]');

        $element.animate({scrollTop: $element.prop("scrollHeight")}, 1000)

        consumer.subscriptions.create(
            {
                channel: "RoomChannel",
                room: room_id
            },
            {
                received: function (data) {
                    const content = messageTemplate.children().clone(true, true);

                    content.find('[data-role="message-author"]').text(data.display_name);
                    content.find('[data-role="message-author"]').attr('href', `/users/${data.user_id}`);
                    content.find('[data-role="message-text"]').text(data.message);
                    content.find('[data-role="message-date"]').text(formatDate(new Date(data.updated_at)));

                    if (data.user_id === document.current_user) {
                        content.addClass('chat-item-me')
                    }
                    $element.append(content);
                    $element.animate({scrollTop: $element.prop("scrollHeight")}, 1000);
                }
            }
        );
    });
});
