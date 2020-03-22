class Api::V1::AuthController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :login
  skip_before_action :verify_authenticity_token if -> { auth_header.present? }

  def login
    user = User.find_by(email: params[:email])
    if user && user.valid_password?(params[:password])
      payload = { user_id: user.id }
      token = encode_token(payload)
      render json: { user: user, jwt: token, success: "Welcome back, #{user.name}" }, status: :created
    else
      render json: { failure: "Log in failed!" }
    end
  end

  def auto_login
    if session_user
      render json: session_user
    else
      render json: { errors: "No User logged In" }
    end
  end
end
