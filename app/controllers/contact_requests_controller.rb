class ContactRequestsController < ApplicationController
  before_action :authenticate_user!

  def create
    requested_user = User.find(params[:user_id])
    requested_user.contact_requests << current_user
    requested_user.save
    redirect_to users_path
  end

  def index
    @requests = current_user.contact_requests
  end

  def destroy
    current_user.contact_requests.delete(params[:id])
    redirect_to user_contact_requests_path(current_user), notice: t('user.contact_request.denied')
  end

  def accept
    user = User.find(params[:id])
    user.contacts << current_user
    user.save
    current_user.contact_requests.delete(params[:id])
    redirect_to user_contact_requests_path(current_user), notice: t('user.contact_request.approved')
  end
end
