class JitsiCallsController < ApplicationController
  before_action :authenticate_user!

  def create
    @jitsi_call = JitsiCall.new(room_name: SecureRandom.uuid)
    if @jitsi_call.save && User.exists?(call_params[:participant_id])
      assign_participants
    else
      redirect_to root_path, alert: I18n.t('denial.resource_creation', resource: JitsiCall)
    end
  end

  def assign_participants
    @jitsi_call.call_participants.create(state: 'accepted', role: 'initiator', user: current_user)
    @jitsi_call.call_participants.create(state: 'requested',
                                         role: 'participant',
                                         user: User.find(call_params[:participant_id]))
  end

  def call_params
    params.require(:jitsi_call).permit(:participant_id)
  end
end
