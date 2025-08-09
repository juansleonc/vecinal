class Api::V1::ReservationsController < ApplicationController
  def index
    render json: []
  end

  def show
    render json: { error: 'not found' }, status: :not_found
  end
end
