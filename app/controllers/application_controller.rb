class ApplicationController < ActionController::Base
  include ApplicationHelper
  include Pundit

  # after_action :verify_authorized, except: :index
  # after_action :verify_policy_scoped, only: :index

  before_action :set_time_from_params

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  respond_to :html

  protected

  def authorized_associated_objects(object, *fields)
    policy = policy(object)

    associated_objects_class = policy.class::AssociatedObjects
    associated_objects = associated_objects_class.new(current_user, object).send(action_name.to_s + "?")
    values = fields.map{ |field| associated_objects[field ] }

    if values.size == 1
      values.first
    else
      values
    end
  end

  def policy_scope_with_args(object_or_class, *args)
    current_user.authorize_args = args
    policy_scope object_or_class
  end

  def authorize_with_args(object_or_class, *args)
    current_user.authorize_args = args
    authorize object_or_class
  end

  def selected_account
    current_user.selected_account
  end

  private

  def set_time_from_params
    if Rails.env.development?
      if params[:time]
        m = /((\d+)_(\d+)_(\d+)T)?(\d+)_(\d+)/.match(params[:time])
        puts "m = #{m}"
        if m
          if m[1]
            month = m[2].to_i
            day = m[3].to_i
            year = m[4].to_i
          else
            month, day, year = Time.now.month, Time.now.day, Time.now.year
          end

          hour = m[5].to_i
          minute = m[6].to_i

          Timecop.freeze(year, month, day, hour, minute)
        else
          Timecop.return
        end
      else
        Timecop.return
      end
    end
  end

  # each controller can have its own "user_not_authorized" method
  def user_not_authorized
    flash[:alert] = 'User does not have permission to access this page'
    redirect_to root_path
  end
end