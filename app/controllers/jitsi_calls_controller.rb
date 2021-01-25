class JitsiCallsController < ApplicationController
  before_action :authenticate_user!

  def create
    puts params.inspect
  end
end
