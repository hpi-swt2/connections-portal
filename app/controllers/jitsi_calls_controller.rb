class JitsiCallsController < ApplicationController
  before_action :authenticate_user!

  def create
    return unless check_user_availability

    @jitsi_call = JitsiCall.new(room_name: SecureRandom.uuid)
    if @jitsi_call.save
      assign_participants
      notify_participants
      notify_initiator
    else
      redirect_to root_path, alert: I18n.t('denial.resource_creation', resource: JitsiCall)
    end
  end

  def accept
    call = JitsiCall.find(params[:id])
    return unless call.invitation(current_user).state == MeetingInvitation.state_requested

    change_call_invitation_state(call, MeetingInvitation.state_accepted)

    data = { action: :start_call, url: call.url, popup_text: I18n.t('call.starting') }
    send_notification(current_user, **data)
    send_notification(call.initiator, **data)
  end

  def reject
    call = JitsiCall.find(params[:id])
    return unless call.invitation(current_user).state == MeetingInvitation.state_requested

    change_call_invitation_state(call, MeetingInvitation.state_rejected)

    send_notification(
      call.initiator,
      action: :simple_message,
      popup_text: I18n.t('call.rejected', guest: current_user.display_name),
      dismiss: I18n.t('confirmation.dismiss')
    )
  end

  # The initiator cancels a outgoing call
  def abort
    call = JitsiCall.find(params[:id])
    return if call.started?

    unless call.initiator == current_user && (call.invitation(current_user).state == MeetingInvitation.state_accepted)
      return
    end

    cancel_call(call)
  end

  def assign_participants
    @jitsi_call.meeting_invitations.create(state: MeetingInvitation.state_accepted,
                                           role: MeetingInvitation.role_initiator,
                                           user: current_user)
    @jitsi_call.meeting_invitations.create(state: MeetingInvitation.state_requested,
                                           role: MeetingInvitation.role_guest,
                                           user: User.find(call_params[:guest_id]))
    @jitsi_call.reload
  end

  def call_params
    params.require(:jitsi_call).permit(:guest_id)
  end

  private

  def change_call_invitation_state(call, new_state)
    call.invitation(current_user).state = new_state
  end

  def notify_participants
    @jitsi_call.guests.each do |guest|
      send_notification(
        guest, action: :invited_to_call,
               accept_text: I18n.t('call.accept'),
               accept_url: accept_jitsi_call_path(@jitsi_call),
               reject_text: I18n.t('call.reject'),
               reject_url: reject_jitsi_call_path(@jitsi_call),
               popup_text: I18n.t('call.notification_incoming_call', initiator: @jitsi_call.initiator.display_name)
      )
    end
  end

  def check_user_availability
    is_user_available = User.find(call_params[:guest_id])&.current_status == User.filter_status
    unless is_user_available
      send_notification(
        current_user,
        action: :simple_message,
        popup_text: I18n.t('call.creation_fail'),
        dismiss: I18n.t('confirmation.dismiss')
      )
    end
    is_user_available
  end

  def cancel_call(call)
    change_call_invitation_state(call, MeetingInvitation.state_rejected)

    call.guests.each do |guest|
      send_notification(
        guest,
        action: :simple_message,
        popup_text: I18n.t('call.aborted', initiator: current_user.display_name),
        dismiss: I18n.t('confirmation.dismiss')
      )
    end
  end

  def notify_initiator
    send_notification(
      @jitsi_call.initiator,
      action: :wait_for_call_guests,
      popup_text: I18n.t('call.waiting'),
      abort_url: abort_jitsi_call_path(@jitsi_call),
      abort_text: I18n.t('call.abort')
    )
  end
end
