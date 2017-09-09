class ApplicationController < ActionController::Base
  include ApplicationHelper
  include Pundit

  # after_action :verify_authorized, except: :index
  # after_action :verify_policy_scoped, only: :index

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  respond_to :html

  private

  # each controller can have its own "user_not_authorized" method
  def user_not_authorized
    flash[:alert] = 'User does not have permission to access this page'
    redirect_to root_path
  end
end