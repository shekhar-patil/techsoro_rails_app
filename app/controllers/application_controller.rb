class ApplicationController < ActionController::Base
  def encode_token(payload)
    JWT.encode(payload, 'my_scret_key123')
  end

  def session_user
    decode_hash = decode_token
    unless decode_hash.blank?
      user_id = decode_hash[0]['user_id']
      @user = User.find_by(id: user_id)
    else
      nil
    end
  end

  def auth_header
    request.headers['Authorization']
  end

  def decode_token
    if auth_header
      token = auth_header.split(' ')[1]
      begin
        JWT.decode(token, 'my_scret_key123', true, algorithm: 'HS256')
      rescue JWT::DecodeError
        Rails.logger.info "Error in JWT decode #{JWT::DecodeError}"
      end
    end
  end

  def logged_in?
    !!session_user
  end

  def login_require
    render json: {message: 'Please Login' }, status: :unauthorized unless logged_in?
  end
end
