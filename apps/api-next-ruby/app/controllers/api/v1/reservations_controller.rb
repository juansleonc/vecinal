class Api::V1::ReservationsController < ApplicationController
  def index
    reservations = Reservation.all
    reservations = reservations.where(amenity_id: params[:amenityId]) if params[:amenityId].present?
    if params[:from].present?
      reservations = reservations.where('date >= ?', params[:from])
    end
    if params[:to].present?
      reservations = reservations.where('date <= ?', params[:to])
    end
    reservations = reservations.order(created_at: :desc)
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
      reserver_id: current_user_id || SecureRandom.uuid,
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
    record = Reservation.find(params[:id])
    update_attrs = {}
    update_attrs[:status] = body[:status] if body[:status].present?
    update_attrs[:responsible_id] = body[:responsibleId] if body[:responsibleId].present?
    record.update!(update_attrs) if update_attrs.any?
    render json: serialize(record)
  end

  def destroy
    record = Reservation.find(params[:id])
    record.destroy!
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
