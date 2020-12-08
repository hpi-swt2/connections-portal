class ContactsController < ApplicationController
  def show
    render params[:page]
  end
end
