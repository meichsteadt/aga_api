class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]
  before_action :require_login
  # GET /users/1
  def show
    if @user
      render json: {"user": @user.as_json(except: [:password_digest]), "emails": @user.emails}
    else
      render json: {"message": "user not authenticated"}
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
      params.permit(:login, :password, :bedroom_mult, :dining_mult, :seating_mult)
    end
end
