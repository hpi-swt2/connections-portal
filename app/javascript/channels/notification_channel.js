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
        console.log("accepted a call", data.url);
        generatePopup(
            data.popup_text,
            "fa-external-link",
            [],
            5000
        )
        window.open(data.url, '_blank');
    },

    // The requested call got rejected. Let's stop waiting
    call_was_rejected(data) {
        console.log("rejected a call")
        generatePopup(
            data.popup_text,
            "fa-times",
            [
                {
                    "label": data.ok_rejected,
                    "action": () => {},
                    "hideAfterClick": true
                }
            ],
            10000
        )
    },

    // A call is incoming. Let's display it...
    invited_to_call(data) {
        console.log("answer call?", data)
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
        console.log("waiting for call guests")
        generatePopup(
            data.popup_text,
            "fa-spinner",
            [
                {
                    "label": data.okay,
                    "action": () => {},
                    "hideAfterClick": true
                }
            ]
        )
    }
})
