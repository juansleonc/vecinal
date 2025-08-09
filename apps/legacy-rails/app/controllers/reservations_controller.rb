class ReservationsController < ApplicationController

  load_and_authorize_resource
  
  def create
    @reservation.user = current_user if @reservation.reserver.nil?
    @reservation.save
  end
  
  def index
    params[:order] ||= 'last'
    params[:status] ||= nil
    params[:responsible] ||= current_user
    filter_communities

    @reservations = @reservations.includes(:reserver, :amenity => :building, comments: :attachments)
    if params[:b].present?
      @reservations = @reservations.where("buildings.id = #{params[:b]}")
    end
    

    if params[:order] == 'last'
      @reservations = @reservations.order(:id => 'DESC')
    elsif params[:order] == 'oldest'
      @reservations = @reservations.order(:id => 'ASC')
    elsif params[:order] == 'asc'
      @reservations = @reservations.order(:message => params[:order])
    elsif params[:order] == 'desc'  
      @reservations = @reservations.order(:message => params[:order])
    else
      @reservations = @reservations.order(:id => 'DESC')
    end

    if params[:month].present?
      date_filter = DateTime.new(Date.today.year, params[:month].to_i, 1)
      @reservations = @reservations.where(:date => date_filter.beginning_of_month..date_filter.end_of_month )
    end

    unless params[:status].nil?
      @reservations = @reservations.where(status: params[:status])  
    end 

    if params[:responsible].present? && params[:responsible] != 'all'
      @reservations = @reservations.where(responsible_id: params[:responsible])
    end
    

    @reservations = @reservations.paginate(page: params[:page], per_page: Reservation::PER_PAGE)
    load_more_at_bottom_respond_to @reservations
  end

  def get_schedule
    if params[:date_selected].present?
      reservations = Reservation.where('status != ? AND date = ? AND amenity_id = ?',"cancelled", params[:date_selected], params[:amenity_id])
      render json: reservations.to_json
    else
      render :json => { success: false }.to_json
    end
  end
  

  def create_comment(content)
    Comment.create user_id: current_user.id, commentable_type: @reservation.class.name, commentable_id: @reservation.id,
      content: content
  end

  def change_status
    if @reservation.update status: params[:status]
      @comment = Comment.create(
        user: current_user,
        commentable: @reservation,
        content: t("reservations.changed_status_to_#{@reservation.status}") 
      )
    end
  end

  def change_responsible
    @reservation.update responsible_id: params[:responsible_id]
    UserMailer.change_responsible_reservation(@reservation, @reservation.responsible).deliver_later
    create_comment t('service_requests.change_responsible', responsible: @reservation.responsible.full_name)
    redirect_to reservations_path

  end

  def destroy
    @reservation.destroy
  end

  def mark_as_read
    @reservation.mark_as_read! for: current_user
  end
  def filter_communities
    count_by_amenity = @reservations.includes(:reserver, :amenity, comments: :attachments).group(:amenity_id).count
    @contacts_by_accountable = [];
    qty_company = 0
    add_company = 'Company-' + current_user.my_company.id.to_s
    list_building = []
    @contacts_by_accountable = []
    building_uses = {}

    current_user.my_company.buildings.each do |building|
      add_building = 'Building-' + building[:id].to_s
      qty = 0
      building_uses[add_building] = qty
    end
    
    @reservations.each do |reservation|
      key_building = 'Building-' + reservation.amenity.building_id.to_s
      building_uses[key_building] = count_by_amenity[reservation.amenity.id].to_i
    end
    @contacts_by_accountable = [building_uses]
    @total_invites = 0
    @contacts_by_accountable.each do |invites|
      invites.each do |invite, value|
        @total_invites += value.to_i
      end
    end
  end
  def search
    
    filter_communities
    @reservations = @reservations.search_by(params[:query])
    if params[:b].present?
      @reservations = @reservations.where("buildings.id = #{params[:b]}")
    end
    @reservations = @reservations.paginate(page: params[:page], per_page: Reservation::PER_PAGE)
    load_more_at_bottom_respond_to @reservations
  end

private

  def create_params
    params.require(:reservation).permit(:amenity_id, :date, :time_from, :time_to, :message, :reserver_id, :responsible_id)
  end


end
