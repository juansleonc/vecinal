class AmenitiesController < ApplicationController
  load_and_authorize_resource
  before_action :order_by, only: [:index, :search]
  before_action :communities_filter, only: [:index, :search]
  def order_by
    params[:order] ||= 'asc'
    if params[:order].empty?
      params[:order] = 'asc'
    end
  end
  
  def index
    communities_filter

    @param_building = params[:b] if params[:b].present?
    @param_company = params[:c] if params[:c].present?

    if @param_building 
      @amenities = @amenities.where(:building =>  @param_building)
    else
      @amenities = @amenities.includes(:building)
    end
    
  

    if params[:order] == 'last'
      @amenities = @amenities.order(:id => 'DESC').availability.paginate(page: params[:page], per_page: Amenity::PER_PAGE)
    elsif params[:order] == 'oldest'
      @amenities = @amenities.order(:id => 'ASC').availability.paginate(page: params[:page], per_page: Amenity::PER_PAGE)
    else
      @amenities = @amenities.order(:name => params[:order].to_sym).availability.paginate(page: params[:page], per_page: Amenity::PER_PAGE)
    end
    
    @total = @amenities.count
    
    load_more_at_bottom_respond_to @amenities
  end

  def communities_filter
    group_building = @amenities.group(:building_id).count
    @contacts_by_accountable = [];
    group_building.each do |id,qty|
      @contacts_by_accountable.push('Building-' + id.to_s => qty);
      
    end
    
    @total_invites = 0
    @contacts_by_accountable.each do |invites|
      invites.each do |invite, value|
        @total_invites += value
      end
    end
  end

  def show
    @about_btn = 'active'
  end

  def create
    @amenity.save
  end

  def update
    @amenity.update update_params
  end

  def destroy
    @amenity.destroy
    respond_to do |format|
      format.html do
        if @amenity.destroyed?
          redirect_to amenities_path
        else
          flash.now[:error] = @amenity.errors.full_messages.join(', ')
          render :show
        end
      end
      format.js
    end
  end

  def reviews
    @reviews_btn = 'active'
  end

  def photos
    @photos_btn = 'active'
  end

  def calendar
    params[:date] ||= Date.current()
    @filter_date = params[:date]
    @reservations = Reservation.where(amenity_id: params[:id],date: @filter_date)
    @calendar_btn = 'active'
  end

  def search
    @param_building = params[:b] if params[:b].present?
    @param_company = params[:c] if params[:c].present?

    @amenities = @amenities.search_by(params[:query]).includes(:building).paginate(page: params[:page], per_page: Amenity::PER_PAGE)
    if @param_building 
      @amenities = @amenities.where(:building =>  @param_building)
    else
      @amenities = @amenities.includes(:building)
    end
    load_more_at_bottom_respond_to @amenities
  end

  def get_limit_time
    if params[:amenity_id].present?
      amenity = Amenity.find params[:amenity_id]
      render json: amenity.to_json
    else
      render :json => { success: false }.to_json
    end
  end

  def get_operating_schedule
    if params[:date_selected].present? && params[:amenity_id].present?
      amenity = Amenity.find params[:amenity_id]
      
      if amenity.availability_type == 'selected_hours'
        reservation_date = DateTime.parse(params[:date_selected])
        availability = amenity.availabilities.where(day: reservation_date.strftime("%w"))
        render json: availability.to_json
      else
        render json: {}.to_json
      end
    else
      render :json => { success: false }.to_json
    end
  end

private

  def create_params
    params.require(:amenity).permit :building_id, :name, :description, :logo_content_type
  end

  def update_params
    params.require(:amenity).permit :building_id, :name, :rental_fee, :rental_value, :deposit, :deposit_value, :description,
      :maximun_rental_time, :availability_type,:reservation_length,:reservation_interval,
      :reservation_length_type,:max_reservations_per_user,:max_reservations_per_user_type,:auto_approval,
      images_attributes: [:id, :image, :home, :_destroy],
      availabilities_attributes: [:id, :active, :time_from, :time_to]
  end
end
