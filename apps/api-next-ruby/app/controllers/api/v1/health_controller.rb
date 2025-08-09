class Api::V1::HealthController < ApplicationController
  def show
    render json: { status: "ok", version: Rails.version }
  end
end
