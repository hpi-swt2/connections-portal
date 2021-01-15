class SocialAccountsController < ApplicationController
  include SocialAccountsHelper
  before_action :authorize, :set_social_account, only: [:show, :edit, :update, :destroy]
  helper_method :generate_link,  :get_supported_social_networks

  def edit
    @user = User.find(params[:user_id])
  end

  def create
    @user = User.find(params[:user_id])
    @social_account = SocialAccount.new(social_account_params)
    @social_account.user_id = @user.id
    # If the account was created successfully we want to finish the request by redirecting to the edit user page.
    if @social_account.save
      # Redirect to setting since we only add social accounts there
      redirect_to edit_user_path(@user)
    else
      # If the account was created unsuccessfully we want to render the users edit form but still be in the processing of
      # the current request so that the user can correct her/his input.
      handle_error
      render "users/edit"
    end
  end

  def update
    # TODO(ct): @user is nil in this point
    if @social_account.update(social_account_params)
      redirect_to edit_user_path(@social_account.user_id)
    else
      @user = User.find(@social_account.user_id)
      handle_error
      render :edit
    end
  end

  def show
    @user = User.find(@social_account.user_id)
    render :edit
  end

  def index
  end

  def destroy
    @user = User.find(params[:user_id])
    @social_account.destroy
    redirect_to edit_user_path(@user)
  end

  private

  def handle_error
      messages = @social_account.errors.full_messages
      error_heading = I18n.t 'errors.messages.not_saved.other', count: messages.count, resource: SocialAccount
      log = {heading: error_heading, messages: messages}
      flash[:danger] = log
  end

  def set_social_account
    @social_account = SocialAccount.find(params[:id])
  end

  def social_account_params
    params.require(:social_account).permit(:social_network, :user_name)
  end

  def authorize
    authenticate_user!
    if current_user.id.to_s != params[:user_id]
      flash[:danger] = I18n.t 'errors.messages.authentication_failed'
      redirect_to root_path
    end
  end
end
