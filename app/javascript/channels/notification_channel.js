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
        console.log("accepted a call", data.url)
        window.open(data.url, '_blank');
    },

    // The requested call got rejected. Let's stop waiting
    reject_call(data) {
        console.log("rejected a call")
        // ToDo: STop waiting/displaying for the opened invite
    },

    // A call is incoming. Let's display it...
    request_call(data) {
        console.log("answer call?", data)
        const confirmation = confirm("You got a call. Would you like to accept?")
        if (confirmation) {
            alert("See console");
        }

        //         accept_url: accept_jitsi_call_path(@jitsi_call),
        //         reject_url: reject_jitsi_call_path(@jitsi_call),
        //         initiator: @jitsi_call.initiator.user.display_name
    },

    // You requested a call. Let's start waiting
    wait_for_call_guests(data) {
        console.log("waiting for call guests")
        // ToDo: Display waiting Popup
    }
})
