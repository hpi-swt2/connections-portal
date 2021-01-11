class HomeController < ApplicationController
  def dashboard
    @users = User.all
    if user_signed_in?
      render 'dashboard'
    else
      render 'index'
    end
  end
end
