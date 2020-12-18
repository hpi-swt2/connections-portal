class HomeController < ApplicationController
  before_action :authenticate_user!

  def dashboard; end
end
