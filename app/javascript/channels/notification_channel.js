// Client-side which assumes you've already requested
// the right to send web notifications.
import consumer from "./consumer"

consumer.subscriptions.create("NotificationChannel", {
    received(data) {
        const function_name = data.action;
        this[function_name](data);
    },

    // The call gets accepted. Lets open Jitsi in a new Tab
    start_call(data) {
        generatePopup(
            data.popup_text,
            "fa-external-link",
            [],
            5000
        )
        window.open(data.url, '_blank');
    },

    // A call is incoming. Let's display it...
    invited_to_call(data) {
        generatePopup(
            data.popup_text,
            "fa-phone",
            [
                {
                    "label": data.accept_text,
                    "action": () => $.ajax({ type: "PATCH", url: data.accept_url })
                },
                {
                    "label": data.reject_text,
                    "action": () => $.ajax({ type: "PATCH", url: data.reject_url })
                }
            ]
        )
    },

    // You requested a call. Let's start waiting
    wait_for_call_guests(data) {
        generatePopup(
            data.popup_text,
            "fa-spinner",
            [
                {
                  "label": data.abort_text,
                  "action": () => $.ajax({ type: "PATCH", url: data.abort_url })
                }
            ]
        )
    },

    // A simple message that displays some text in a popup
    simple_message(data) {
        generatePopup(
            data.popup_text,
            "fa-info",
            [
                {
                    "label": data.dismiss,
                    "action": () => {},
                    "hideAfterClick": true
                }
            ]
        )
    }
})
