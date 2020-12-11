class ContactsController < ApplicationController

  def show
    @contacts = current_user.contacts

  end
end
