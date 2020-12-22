class UsersController < ApplicationController
  before_action :authorize, except: %i[show index add_contact]

  def show
    @user = User.find(params[:id])
  end

  def edit; end

  def update
    return render :edit unless @user.update(user_params)

    redirect_to @user
  end

  def update_status
    @user.current_status = params[:user][:current_status]
    @user.save
    redirect_to @user
  end

  def index
    @users = User.all
  end

  def send_contact_request
    authenticate_user!
    new_contact = User.find(params[:id])
    new_contact.contact_requests << current_user.id
    new_contact.save
    redirect_to home_index_path
  end

  def view_contact_request
    @requests = current_user.contact_requests
    render 'contacts/requests'
  end

  def deny_contact_request
    current_user.contact_requests.delete(params[:id])
    redirect_to view_contact_request_user_path(current_user)
  end

  private

  def user_params
    params.require(:user).permit(:username, :firstname, :lastname, :birthdate, :place_of_residence)
  end

  def authorize
    authenticate_user!
    if current_user.id.to_s == params[:id]
      @user = current_user
    else
      redirect_to root_path
    end
  end
end
