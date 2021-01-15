class UsersController < ApplicationController
  before_action :authorize

  def show
    @user = User.find(params[:id])
  end

  def edit
    authorize_to_update
  end

  def update
    return unless authorize_to_update
    return render :edit unless @user.update(user_params)

    redirect_to @user
  end

  def update_status
    return unless authorize_to_update

    @user.current_status = params[:user][:current_status]
    @user.save
  end

  def index
    @users = User.all
    @users_to_add = @users.reject do |user|
      current_user.sent_contact_request?(user)
    end
  end

  def add_contact
    authenticate_user!
    current_user.contacts << User.find(params[:id])
    current_user.save
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit(:username, :firstname, :lastname, :birthdate, :place_of_residence)
  end

  def authorize
    authenticate_user!
    return redirect_to root_path, alert: I18n.t('denial.unauthorized') if current_user.nil?

    if params.key?(:id)
      redirect_to users_path, alert: I18n.t('denial.not_found') unless User.exists?(params[:id])
      @user = current_user if current_user.id.to_s == params[:id]
    end
    @user = current_user
  end

  def authorize_to_update
    if current_user.id.to_s != params[:id]
      redirect_to users_path, alert: I18n.t('denial.forbidden')
      return false
    end
    true
  end
end
