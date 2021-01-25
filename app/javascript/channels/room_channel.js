import consumer from './consumer'

$(function () {
    $('[data-channel-subscribe="room"]').each(function (index, element) {
        const $element = $(element);
        const room_id = $element.data('room-id');
        $element.animate({scrollTop: $element.prop("scrollHeight")}, 1000)

        consumer.subscriptions.create(
            {
                channel: "RoomChannel",
                room: room_id
            },
            {
                received: function (data) {
                    const $element = $($('[data-channel-subscribe="room"]')[0]),
                        messageTemplate = $('[data-role="message-template"]');

                    const content = messageTemplate.children().clone(true, true);

                    content.find('[data-role="message-author"]').text(data.display_name);
                    content.find('[data-role="message-author"]').attr('href', data.user_link);
                    content.find('[data-role="message-text"]').text(data.message);
                    content.find('[data-role="message-date"]').text(data.send_date);

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
