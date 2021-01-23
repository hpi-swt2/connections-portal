class ContactsController < ApplicationController
  before_action :authorize!

  def index
    @contacts = current_user.contacts
  end

  private

  def authorize!
    authenticate_user!

    return current_user if current_user.id.to_s == params[:user_id]

    redirect_to users_path, alert: I18n.t('denial.forbidden')
    nil
  end
end
