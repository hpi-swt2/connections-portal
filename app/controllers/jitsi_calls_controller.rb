class JitsiCallsController < ApplicationController
  before_action :authenticate_user!

  def create
    @jitsi_call = JitsiCall.new(room_name: SecureRandom.uuid)

    unless @jitsi_call.save && User.exists?(call_params[:guest_id])
      redirect_to root_path, alert: I18n.t('denial.resource_creation', resource: JitsiCall)
    end

    assign_participants
    notify_participants
    notify_initiator
  end

  def accept
    return unless change_call_state MeetingInvitation.state_accepted

    data = { action: :start_call, url: call.url, popup_text: I18n.t('call.starting') }

    call = JitsiCall.find(params[:id])
    send_notification(current_user, **data)

    # only open meeting for initiator if the current user was the first other user to accept the meeting
    send_notification(call.initiator, **data) if
      call.meeting_invitations.where(state: MeetingInvitation.state_accepted).count == 2
  end

  def reject
    return unless change_call_state MeetingInvitation.state_rejected

    call = JitsiCall.find(params[:id])
    send_notification(
      call.initiator,
      action: :call_was_rejected,
      popup_text: I18n.t('call.rejected'),
      ok_rejected: I18n.t('call.ok_rejected')
    )
  end

  def assign_participants
    @jitsi_call.meeting_invitations.create(state: MeetingInvitation.state_accepted,
                                           role: MeetingInvitation.role_initiator,
                                           user: current_user)
    @jitsi_call.meeting_invitations.create(state: MeetingInvitation.state_requested,
                                           role: MeetingInvitation.role_guest,
                                           user: User.find(call_params[:participant_id]))
    @jitsi_call.reload
  end

  def call_params
    params.require(:jitsi_call).permit(:participant_id)
  end

  private

  def change_call_state(new_state)
    invitation = current_user.meeting_invitations.find_by(jitsi_call_id: params[:id])
    invitation.state = new_state if invitation&.state == MeetingInvitation.state_requested
  end

  def notify_participants
    @jitsi_call.guests.each do |guest|
      send_notification(
        guest.user,
        action: :invited_to_call,
        accept_text: I18n.t('call.accept'),
        accept_url: accept_jitsi_call_path(@jitsi_call),
        reject_text: I18n.t('call.reject'),
        reject_url: reject_jitsi_call_path(@jitsi_call),
        popup_text: I18n.t('call.notification_incoming_call', initiator: jitsi_call.initiator.user.display_name)
      )
    end
  end

  def notify_initiator
    send_notification(
      @jitsi_call.initiator.user,
      action: :wait_for_call_guests,
      popup_text: I18n.t('call.waiting'),
      okay: I18n.t('call.ok_waiting')
    )
  end
end
