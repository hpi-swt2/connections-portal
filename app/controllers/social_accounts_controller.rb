# Since we are using nested routes the user should only see the edit view of a social account. All information of the
# social accounts them self is listed inside the users/edit or users/show views. A request to create a social account
# is sent from inside the context of a user controller. A request to edit a social account is sent from the context of
# this controller. If the creation/update of a social account is not valid, we still want to be in the process of the
# request and give the user the chance to correct the mistake. That means we are still inside the context of this
# controller but using the edit view from users.
class SocialAccountsController < ApplicationController
  include SocialAccountsHelper
  before_action :authorize, :set_social_account, only: %i[show edit update destroy]
  helper_method :generate_link, :supported_social_networks

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
      # If the account was created unsuccessfully we want to render the users edit form but still be in the processing
      # of the current request so that the user can correct her/his input.
      handle_error
      render 'users/edit'
    end
  end

  def update
    if @social_account.update(social_account_params)
      redirect_to edit_user_path(@social_account.user_id)
    else
      @user = User.find(@social_account.user_id)
      handle_error
      render :edit
    end
  end

  def show
    # We should only be at this point if:
    # -> the user sends a request from the edit view rendered by this controller (action update).
    # -> the update of the user account fails.
    # -> The user manually try to reload the page. This triggers a get request on the
    #    route /users/:user_id/social_accounts/:id.
    # We are still in the context of editing a social account so we are rendering the edit view.
    # The edit view needs a user instance variable.
    @user = User.find(params[:user_id])
    render :edit
  end

  def index
    # We should only be at this point if:
    # -> the user sends a request from a form rendered in a view that uses the user controller
    #    to this controller (action create).
    # -> the creation of the user account fails.
    # -> The user manually try to reload the page. This triggers a get request on the
    #    route /users/:user_id/social_accounts.
    # We are still in the context of creating a social account so we are rendering the users/edit view.
    # The edit view needs a user and social_account instance variable from this controller since we
    # are rendering this view with this controller now.
    @user = User.find(params[:user_id])
    @social_account = @user.social_accounts.build
    render 'users/edit'
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
    log = { heading: error_heading, messages: messages }
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
    return unless current_user.id.to_s != params[:user_id]

    message = I18n.t 'errors.messages.authentication_failed'
    log = { heading: nil, messages: [message] }
    flash[:danger] = log
    redirect_to root_path
  end
end
