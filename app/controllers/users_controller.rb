require 'set'

class UsersController < ApplicationController
  include SocialAccountsHelper
  include UsersHelper
  before_action :authorize, except: %i[show index search]
  helper_method :generate_link, :supported_social_networks, :search_record

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

    handle_error
    @social_account = @user.social_accounts.build
    render :edit
  end

  def update_status
    @user.current_status = params[:user][:current_status]
    @user.save
  end

  def index
    @users = User.where.not(id: current_user.id)
    @users_to_add = @users.reject do |user|
      current_user.sent_contact_request?(user)
    end
  end

  def add_contact
    authenticate_user!
    current_user.contacts << User.find(params[:id])
    current_user.save
    redirect_to root_path
  end

  def search
    use_wildcards = false
    @users = Set[]
    @contacts = Set[]
    if current_user and params[:search]
      @user = User.find(current_user.id)
      @users = search_record(params[:search], User, use_wildcards)
      @contacts = search_record(params[:search], @user.contacts, use_wildcards)
      @users - @contacts
    end
    if !current_user and params[:search] 
      @users = search_record(params[:search], User. use_wildcards)
    end
  end

  private

  def handle_error
    messages = @user.errors.full_messages
    error_heading = I18n.t 'errors.messages.not_saved.other', count: messages.count, resource: User
    log = { heading: error_heading, messages: messages }
    flash[:danger] = log
  end

  def user_params
    params.require(:user).permit(:username, :firstname, :lastname, :birthdate, :place_of_residence)
  end

  def authorize
    authenticate_user!
    if current_user.id.to_s == params[:id]
      @user = current_user
    else
      message = I18n.t 'errors.messages.authentication_failed'
      log = { heading: nil, messages: [message] }
      flash[:danger] = log
      redirect_to root_path
    end
  end
end
