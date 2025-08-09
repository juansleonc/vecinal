class HealthController < ApplicationController
  skip_authentication :show
  def show
    render json: { status: "ok" }
  end
end
