class JitsiCallsController < ApplicationController
  before_action :authenticate_user!

  def create
    @jitsi_call = JitsiCall.new(room_name: SecureRandom.uuid)

    unless @jitsi_call.save && User.exists?(call_params[:participant_id])
      redirect_to root_path, alert: I18n.t('denial.resource_creation', resource: JitsiCall)
    end

    assign_participants
    notify_participants
    notify_initiator
  end

  def accept
    return unless change_call_state 'accepted'

    call = JitsiCall.find(params[:id])
    send_notification(current_user, action: :start_call, url: call.url)

    # only open meeting for initiator if the current user was the first other user to accept the meeting
    send_notification(call.initiator, action: :start_call, url: call.url) if
      call.call_participants.where(state: 'accepted').count == 2
  end

  def reject
    return unless change_call_state 'rejected'

    call = JitsiCall.find(params[:id])
    send_notification(call.initiator, action: :reject_call)
  end

  def assign_participants
    @jitsi_call.call_participants.create(state: 'accepted', role: 'initiator', user: current_user)
    @jitsi_call.call_participants.create(state: 'requested',
                                         role: 'guest',
                                         user: User.find(call_params[:participant_id]))
    @jitsi_call.reload
  end

  def call_params
    params.require(:jitsi_call).permit(:participant_id)
  end

  private

  def change_call_state(new_state)
    participant = current_user.call_participants.find_by(jitsi_call_id: params[:id])
    participant.state = new_state if participant&.state == 'requested'
  end

  def notify_participants
    @jitsi_call.guests.each do |guest|
      send_notification(
        guest.user,
        action: :request_call,
        accept_url: accept_jitsi_call_path(@jitsi_call),
        reject_url: reject_jitsi_call_path(@jitsi_call),
        initiator: @jitsi_call.initiator.user.display_name
      )
    end
  end

  def notify_initiator
    send_notification(@jitsi_call.initiator.user, action: :wait_for_call_guests)
  end
end
