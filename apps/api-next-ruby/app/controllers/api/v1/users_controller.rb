class Api::V1::UsersController < ApplicationController
  def me
    user = User.find(current_user_id)
    render json: { id: user.id, email: user.email, roles: [] }
  end
end
