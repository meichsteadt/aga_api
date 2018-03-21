class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]
  before_action :require_login, except: [:index, :create]
  # GET /users/1

  def index
    render json: User.all.as_json(only: [:login])
  end

  def show
    if @user
      render json: {"user": @user.as_json(except: [:password_digest]), "emails": @user.emails}
    else
      render json: {"message": "user not authenticated"}
    end
  end

  def create
    if authenticate(params)
      @user = User.new(user_params)
      if @user.save!
        UserMailer.email_user(@user, params[:password]).deliver_now
        render json: @user.as_json(except: [:password_digest])
      else
        render json: {"message": "Something went wrong"}
      end
    else
      render json: {"message": "Unauthenticated"}
    end
  end

  # PATCH/PUT /users/1
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      render json: {"user": @user.as_json(except: [:password_digest]), "emails": @user.emails}
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      if params[:password]
        params[:password] = Base64.decode64(params[:password])
      end
      params.permit(:login, :password, :bedroom_mult, :dining_mult, :seating_mult, :youth_mult, :occasional_mult, :home_mult)
    end

    def authenticate(params)
      key = Base64.decode64(request.headers["key"])
      secret = Base64.decode64(request.headers["secret"])
      if key == ENV['PAYMENT_KEY'] && secret == ENV['PAYMENT_SECRET']
        true
      else
        false
      end
    end
end
