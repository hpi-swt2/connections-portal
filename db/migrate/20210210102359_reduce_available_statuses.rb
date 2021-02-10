class ReduceAvailableStatuses < ActiveRecord::Migration[6.0]
  def change
    busy_statuses = %w[working offline]
    User.all.each do |user|
      user.current_status = busy_statuses.include?(user.current_status) ? User.status_busy : User.status_free_for_chat
      user.save
    end
  end
end
