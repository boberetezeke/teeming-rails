class ApplicationController < ActionController::API
  before_action :set_current_user, :authenticate_request

  def pagination_dict(collection)
    {
      current_page: collection.current_page,
      next_page: collection.next_page,
      prev_page: collection.prev_page,
      total_pages: collection.total_pages,
      total_count: collection.total_count
    }
  end

  private

  def set_current_user
    if decoded_auth_token
      @current_user = User.find(decoded_auth_token[:user_id])
    end
  end

  def decoded_auth_token
    if request.headers['Authorization'].present?
      token = request.headers['Authorization'].split(' ').last
      JsonWebToken.decode(token)
    end
  end

  def authenticate_request
    unless @current_user
      render json: { errors: "Not Authorized" }, status: :unauthorized
    end
  end
end
