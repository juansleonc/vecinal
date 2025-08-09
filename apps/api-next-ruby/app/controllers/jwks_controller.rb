class JwksController < ApplicationController
  skip_authentication :show

  def show
    keys = Jwks.current_keys
    render json: { keys: keys }
  end
end
