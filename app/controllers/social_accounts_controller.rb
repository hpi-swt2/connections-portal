class SocialAccountsController < ApplicationController
  before_action :set_social_account, only: [:show, :edit, :update, :destroy]
  $supported_social_networks = [["GitHub", "GitHub"], ["Telegram", "Telegram"], ["Facebook", "Facebook"], ["Twitter", "Twitter"], ["GitLab@HPI", "GitLab@HPI"], ["Slack", "Slack"], ["Discord", "Discord"]]

  def generate_link(social_account)
    network = social_account.social_network
      if network == "GitHub"
        return "https://github.com/#{social_account.user_name}"
      end
      if network == "Telegram"
        return "https://t.me/#{social_account.user_name}"
      end
      if network == "Facebook"
        return "https://www.facebook.com/#{social_account.user_name}"
      end
      if network == "Twitter"
        return "https://twitter.com/#{social_account.user_name}"
      end
      if network == "GitLab@HPI"
        return "https://twitter.com/#{social_account.user_name}"
      end
      if network == "Slack"
        return "https://slack.com/"
      end
      if network == "Discord"
        return "https://discordapp.com/#{social_account.user_name}"
      end
      return "#"
  end

  helper_method :generate_link

  def new
  end

  def edit
    @user = User.find(params[:user_id])
    @social_account = @user.social_accounts.find(params[:id])
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
      render "users/edit"
    end
  end

  def update
    # TODO(ct): @user is nil in this point
    if @social_account.update(social_account_params)
      redirect_to edit_user_path(@social_account.user_id)
    else
      @user = User.find(@social_account.user_id)
      render :edit
    end
  end

  def index
    # WORKAROUND because URL is wrong after creating an invalid account from
    # the user edit page
    redirect_to user_path(params[:user_id])
  end

  def destroy
    @user = User.find(params[:user_id])
    @social_account = @user.social_accounts.find(params[:id])
    @social_account.destroy
    redirect_to edit_user_path(@user)
  end

  private
  def set_social_account
    @social_account = SocialAccount.find(params[:id])
  end

  def social_account_params
    params.require(:social_account).permit(:social_network, :user_name)
  end
end
