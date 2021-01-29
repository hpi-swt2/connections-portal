require 'set'

class UsersController < ApplicationController
  include SocialAccountsHelper
  include UsersHelper
  before_action :authorize, except: %i[show index search]
  helper_method :generate_link, :supported_social_networks, :search_record

  def show
    if authenticate_user!
      @user = User.find(params[:id])
      return
    end
    redirect_to(new_user_session_path)
  end

  def edit
    return unless authorize_to_update!

    @user = User.find(params[:id])
    # prototype for create social account form
    @social_account = @user.social_accounts.build
  end

  def update
    return unless authorize_to_update!
    # prototype for create social account form
    return redirect_to @user if @user.update(user_params)

    handle_error
    @social_account = @user.social_accounts.build
    render :edit
  end

  def update_status
    return unless authorize_to_update!

    @user.current_status = params[:user][:current_status]
    @user.save
  end

  def index
    @users = User.all
    @users_to_add = (@users - [current_user]).reject do |user|
      current_user.sent_contact_request?(user)
    end
  end

  def add_contact
    authenticate_user!
    current_user.contacts << User.find(params[:id])
    current_user.save
    redirect_to root_path
  end

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  def search
    use_wildcards = true
    @users = Set[]
    @contacts = Set[]
    if current_user && params[:search]
      @user = User.find(current_user.id)
      @users = search_record(params[:search], User, use_wildcards)
      @contacts = search_record(params[:search], @user.contacts, use_wildcards)
      @users -= @contacts
      @users -= Set[@user]
    end
    @users = search_record(params[:search], User, use_wildcards) if !current_user && params[:search]
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength

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
    return unless params.key?(:id)

    redirect_to users_path, alert: I18n.t('denial.not_found') unless User.exists?(params[:id])
    update_user
  end

  def authorize_to_update!
    return @user if current_user.id.to_s == params[:id]

    message = I18n.t 'errors.messages.authentication_failed'
    log = { heading: nil, messages: [message] }
    flash[:danger] = log
    redirect_to users_path, alert: I18n.t('denial.forbidden')
    nil
  end

  def update_user
    @user = current_user.id.to_s == params[:id] ? current_user : User.find(params[:id])
  end
end
