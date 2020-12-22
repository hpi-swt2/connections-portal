class ContactRequestsController < ApplicationController
  def create
    # authenticate_user!
    requested_user = User.find(params[:user_id])
    requested_user.contact_requests << current_user
    requested_user.save
    redirect_to home_index_path
  end

  def index
    @requests = current_user.contact_requests
  end

  def destroy
    current_user.contact_requests.delete(params[:id])
    redirect_to view_contact_request_user_path(current_user)
  end

  def accept

  end
end