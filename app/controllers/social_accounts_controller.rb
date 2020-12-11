class SocialAccountsController < ApplicationController
    before_action :set_social_account, only: [:show, :edit, :update, :destroy]
  
    def new
    end

    def edit
    end

    def create
        @user = User.find(params[:user_id])
        @social_account = @user.social_accounts.create(social_account_params)
        # TODO(Alexander-Dubrawski) Add Redirection 
    end

    def update
        if @social_account.update(social_account_params)
            # TODO(Alexander-Dubrawski) Add Redirection 
        else
            # TODO(Alexander-Dubrawski) Add Redirection 
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
