class ContactRequestsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_user, only: [:accept]

  def create
    @requested_user = User.find(params[:user_id])
    return if @requested_user.contact_requests.include? current_user
    @requested_user.contact_requests << current_user
    @saved = @requested_user.save
  end

  def index
    @requests = current_user.contact_requests
  end

  def destroy
    current_user.contact_requests.delete(params[:id])
    redirect_to user_contact_requests_path(current_user), notice: t('user.contact_request.denied')
  end

  def accept
    @user.contacts << current_user
    current_user.contact_requests.delete(@user)
    redirect_to user_contact_requests_path(current_user), notice: t('user.contact_request.approved')
  end

  def find_user
    @user = User.find(params[:id])
  end
end
