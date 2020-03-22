class Api::V1::UsersController < ApplicationController
  skip_before_action :verify_authenticity_token if -> { auth_header.present? }
  before_action :login_require

  def index
    @users = User.all
    respond_to do |format|
      format.html
      format.json { render json: @users, status: :ok }
    end
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find_by(id: params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @user, status: 200 }
    end
  end

  def create
    @user = User.create(user_params)
    if @user.valid?
      payload = { user_id: @user.id }
      token = encode_token(payload)
      respond_to do |format|
        format.html
        format.json { render json: { user: @user, jwt: token } , status: :created }
      end
    else
      render json: @user.errors.full_messages, status: :unprocessable_entity
    end
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      respond_to do |format|
        format.html
        format.json { render json: @user, status: :created }
      end
    else
      render json: @user.errors.full_messages, status: :unprocessable_entity
    end
  end

  def destroy
    @user = User.find(params[:id])

    if @user.destroy
      respond_to do |format|
        format.html
        format.json { render json: @user, status: :no_content }
      end
    else
      render json: @user.errors.full_messages, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user)
          .permit(:name, :email, :password, :password_confirmation)
  end
end
