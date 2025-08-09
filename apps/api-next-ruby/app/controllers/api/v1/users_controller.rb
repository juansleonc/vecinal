class Api::V1::UsersController < ApplicationController
  def me
    render json: { id: current_user_id }
  end
end
