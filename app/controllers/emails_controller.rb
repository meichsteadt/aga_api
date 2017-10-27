class EmailsController < ApplicationController
  before_action :set_email, only: [:show, :update, :destroy]

  # GET /emails
  def index
    @emails = Email.all

    render json: @emails
  end

  # POST /emails
  def create
    @user = User.find(params[:user_id])
    @email = @user.emails.new(email_params)
    @email.product_number = Product.find(@email.product_id).number
    if @email.save
      ProductMailer.email_product(@email.email_address, @email.product_id).deliver!
      render json: @email, status: :created, location: @email
    else
      render json: @email.errors, status: :unprocessable_entity
    end
  end

  # DELETE /emails/1
  def destroy
    @email.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_email
      @email = Email.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def email_params
      params.permit(:email_address, :product_id, :login, :password)
    end
end
