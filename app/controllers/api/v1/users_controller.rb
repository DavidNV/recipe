class Api::V1::UsersController < ApplicationController
  VALID_PARAMS = [:user_id, :password, :nickname, :comments].freeze
  before_action :set_user_from_token, only: [:show, :update, close]

  def signup
    user = User.new(permitted_params)
    if user.valid? && user.save
      response = {
        message: "Account successfully created",
        user: {
          user_id: user.user_id,
          nickname: user.nickname
        }
      }
      render json: response, status: 200
    else
      render json: base_error_response("Account creation failed!", user.get_error), status: 400
    end
  end

  def show
    if(@properToken)
      render json: base_error_response("Authentication Failed", ""), status: 401
    elsif(@user)
      response = {
        message: "User details by user id",
        user: {
          user_id: @user.user_id,
          nickname: @user.nickname
        }
      }
      render json: response, status: 200
    else
      render json: base_error_response("No User found", ""), status: 404
    end
  end

  def update
    if(@properToken)
      render json: base_error_response("Authentication Failed", ""), status: 401
    elsif(@user)
      target_user = User.find_by(user_id: permitted_params[:id])
      if target_user.id != @user.id
        render json: base_error_response("No Permission for Update", ""), status: 401
      else
        response = {
          message: "User details by user id",
          user: {
            user_id: @user.user_id,
            nickname: @user.nickname
          }
        }
        render json: response, status: 200
      end
    else
      render json: base_error_response("No User found", ""), status: 404
    end
  end

  def close
    if(@properToken)
      render json: base_error_response("Authentication Failed", ""), status: 401
    elsif(@user)
      @user.delete
      response = {
        message: "Account and User successfully removed",
      }
      render json: response, status: 200
    end
  end

  private

  def permitted_params
    params.permit(*VALID_PARAMS)
  end

  def base_error_response(message, caused)
    { 
      message: message,
      caused: caused
    }
  end

  def set_user_from_token
    token = request.authorization
    decoded_token = Base64.decode64(token)
    user_id, password = decoded_token.split(':')[0], decoded_token.split(':')[1]
    @properToken = user_id.present? && password.present?

    @user = User.find_by(user_id: user_id, password: password)
  end

end
