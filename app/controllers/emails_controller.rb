class EmailsController < ApplicationController
  before_action :set_email, only: [:show, :update, :destroy]

  # GET /emails
  def index
    @emails = Email.all

    render json: @emails
  end

  # GET /emails/1
  def show
    render json: @email
  end

  # POST /emails
  def create
    @email = Email.new(email_params)
    if @email.save
      ProductMailer.email_product(@email.email_address, @email.product_id).deliver_later
      render json: @email, status: :created, location: @email
    else
      render json: @email.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /emails/1
  def update
    if @email.update(email_params)
      render json: @email
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
      params.permit(:email_address, :product_id)
    end
end
