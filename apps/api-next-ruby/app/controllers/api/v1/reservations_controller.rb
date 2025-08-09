class Api::V1::ReservationsController < ApplicationController
  def index
    reservations = Reservation.all.order(created_at: :desc)
    render json: reservations.map { |r| serialize(r) }
  end

  def show
    reservation = Reservation.find(params[:id])
    render json: serialize(reservation)
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

    record = Reservation.create!(
      amenity_id: payload[:amenityId],
      reserver_id: SecureRandom.uuid,
      responsible_id: nil,
      date: payload[:date],
      time_from: payload[:timeFrom],
      time_to: payload[:timeTo],
      status: 'pending',
      message: payload[:message]
    )

    render json: serialize(record), status: :created
  end

  def update
    body = params.require(:reservation).permit(:status, :responsibleId)
    allowed_status = %w[pre-approved approved cancelled]

    if body[:status].present? && !allowed_status.include?(body[:status])
      render json: { errors: ["invalid status"] }, status: :unprocessable_entity
      return
    end

    # Fake update since we don't persist user context yet
    Reservation.find(params[:id]) # raise not found if missing
    render json: { ok: true }
  end

  def destroy
    head :no_content
  end

  private

  def serialize(record)
    {
      id: record.id,
      amenityId: record.amenity_id,
      reserverId: record.reserver_id,
      responsibleId: record.responsible_id,
      date: record.date,
      timeFrom: record.time_from,
      timeTo: record.time_to,
      status: record.status,
      message: record.message,
      createdAt: record.created_at&.iso8601,
      updatedAt: record.updated_at&.iso8601
    }
  end
end
