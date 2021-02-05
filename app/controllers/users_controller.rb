class UsersController < ApplicationController
  include SocialAccountsHelper
  before_action :authorize
  helper_method :generate_link, :supported_social_networks

  def show; end

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
    @users = User.search(params[:search]).where.not(id: current_user.id)
    @users_to_add = @users.reject do |user|
      current_user.sent_contact_request?(user)
    end
    @user_contacts = current_user.contacts
  end

  private

  def handle_error
    messages = @user.errors.full_messages
    error_heading = I18n.t 'errors.messages.not_saved.other', count: messages.count, resource: User
    log = { heading: error_heading, messages: messages }
    flash[:danger] = log
  end

  def user_params
    params.require(:user).permit(:username, :firstname, :lastname, :birthdate, :place_of_residence, :avatar)
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
