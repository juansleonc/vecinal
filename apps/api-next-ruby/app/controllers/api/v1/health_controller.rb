class Api::V1::HealthController < ApplicationController
  skip_authentication :show
  def show
    render json: { status: "ok", version: Rails.version }
  end
end
