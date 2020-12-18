class SocialAccountsController < ApplicationController
  before_action :set_social_account, only: [:show, :edit, :update, :destroy]

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
    if @social_account.save
      # Redirect to setting since we only add social accounts there
      redirect_to edit_user_path(@user)
    else
      @user.social_accounts.destroy(@social_account)
      @social_account.destroy
      render :edit
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

  def destroy
    @social_account.destroy
    # TODO(Alexander-Dubrawski) Add Redirection 
  end

  private
  def set_social_account
    @social_account = SocialAccount.find(params[:id])
  end

  def social_account_params
    params.require(:social_account).permit(:social_network, :user_name)
  end
end
