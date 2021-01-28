class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  layout :set_layout

  before_action :set_variant
  before_action :configure_permitted_parameters,
                if: :devise_controller?

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update) do |u|
      u.permit(:avatar, :email, :password, :password_confirmation,
               :current_password)
    end
  end

  private

  def render_not_found
    render file: Rails.root.join('public/404.html'), layout: false, status: :not_found
  end

  def set_variant
    request.variant = :mobile if mobile?
  end

  def set_layout
    mobile? ? 'mobile' : 'desktop'
  end

  def mobile?
    request.user_agent =~ /Mobile|webOS/
  end
end
