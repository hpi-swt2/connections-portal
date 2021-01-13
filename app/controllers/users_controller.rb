class UsersController < ApplicationController
  include SocialAccountsHelper
  before_action :authorize, except: %i[show index]
  helper_method :generate_link,  :get_supported_social_networks


  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
    # prototype for create social account form
    @social_account = @user.social_accounts.build #
  end

  def update
    # prototype for create social account form
    return redirect_to @user if @user.update(user_params)
    @social_account = @user.social_accounts.build
    render :edit
  end

  def update_status
    @user.current_status = params[:user][:current_status]
    @user.save
    redirect_to @user
  end

  def index
    @users = User.all
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
