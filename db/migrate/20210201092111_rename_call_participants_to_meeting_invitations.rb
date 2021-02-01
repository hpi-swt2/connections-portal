class RenameCallParticipantsToMeetingInvitations < ActiveRecord::Migration[6.0]
  def change
    rename_table :call_participants, :meeting_invitations
  end
end
