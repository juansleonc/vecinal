class Api::V1::ReservationsController < ApplicationController
  def index
    render json: { data: [], meta: { count: 0 } }
  end

  def show
    render json: { error: 'not found' }, status: :not_found
  end
end
