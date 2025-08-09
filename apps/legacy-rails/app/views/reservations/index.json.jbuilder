json.array!(@reservations.where(amenity_id: params[:amenity_id])) do |reservation|   
    json.extract! reservation, :id, :status, :amenity_id
    json.title ''
    json.description reservation.message    
    json.start  (reservation.date.to_s + ' ' + reservation.time_from.to_s).to_time
    json.end (reservation.date.to_s + ' ' + reservation.time_to.to_s).to_time
end