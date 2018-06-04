class ApplicationController < ActionController::Base
  def require_login
    authenticate_token || render_unauthorized("Access denied")
  end

  def current_user
    @current_user ||= authenticate_token
  end

  protected

  def render_unauthorized(message)
    errors = { errors: [ { detail: message } ] }
    render json: errors, status: :unauthorized
  end

  private

  def authenticate_token
    authenticate_with_http_token do |token, options|
      User.find_by(auth_token: token)
    end
  end

  def authenticate_key
    key = Base64.decode64(request.headers["key"])
    secret = Base64.decode64(request.headers["secret"])
    unless key == ENV['PRODUCT_KEY'] && secret == ENV['PRODUCT_SECRET']
      render_unauthorized("unauthorized access")
    end
  end
end
