class Api::V1::ReservationsController < ApplicationController
  def index
    render json: []
  end

  def show
    render json: { error: 'not found' }, status: :not_found
  end

  def create
    payload = params.require(:reservation).permit(:amenityId, :date, :timeFrom, :timeTo, :message)

    errors = []
    errors << 'amenityId is required' if payload[:amenityId].blank?
    errors << 'date is required' if payload[:date].blank?
    errors << 'timeFrom is required' if payload[:timeFrom].blank?
    errors << 'timeTo is required' if payload[:timeTo].blank?
    errors << 'message is required' if payload[:message].blank?

    if errors.any?
      render json: { errors: errors }, status: :unprocessable_entity
      return
    end

    reservation = {
      id: SecureRandom.uuid,
      amenityId: payload[:amenityId],
      reserverId: SecureRandom.uuid,
      responsibleId: nil,
      date: payload[:date],
      timeFrom: payload[:timeFrom],
      timeTo: payload[:timeTo],
      status: 'pending',
      message: payload[:message],
      createdAt: Time.now.utc.iso8601,
      updatedAt: Time.now.utc.iso8601
    }

    render json: reservation, status: :created
  end
end
