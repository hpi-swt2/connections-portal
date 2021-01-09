class UsersController < ApplicationController
  before_action :authorize, except: %i[show index]
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
    if @user.update(user_params)
       redirect_to @user
       return
    end
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
