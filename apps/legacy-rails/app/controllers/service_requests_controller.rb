class ServiceRequestsController < ApplicationController

  load_and_authorize_resource
  

  def index
    params[:order] ||= 'last'
    params[:responsible] ||= current_user

    group_building = current_user.my_company.buildings
    add_company = 'Company-' + current_user.my_company.id.to_s
    @contacts_by_accountable = [];
    qty_company = 0
    tmp = @service_requests
    @service_requests.open.with_read_marks_for(current_user).includes(:user, :responsible, comments: [:commentable, :user]).each do |service|
      service_accountable = service.user.accountable.class.name + '-' + service.user.accountable.id.to_s
      if add_company == service_accountable
        qty_company += 1
      end
    end
    @contacts_by_accountable.push(add_company => qty_company)

    group_building.each do |building|
      add_building = 'Building-' + building[:id].to_s
      qty = 0
      @service_requests.open.with_read_marks_for(current_user).includes(:user, :responsible, comments: [:commentable, :user]).each do |service|
        service_accountable = service.user.accountable.class.name + '-' + service.user.accountable.id.to_s
        if add_building == service_accountable
          qty += 1
        end

      end 
      @contacts_by_accountable.push(add_building => qty)
    end
    
  
    @total_invites = 0
    @contacts_by_accountable.each do |invites|
      invites.each do |invite, value|
        @total_invites += value
      end
    end

    @service_requests = tmp.open.with_read_marks_for(current_user).includes(:responsible,user: [:accountable],  comments: [:commentable, :user])
    
    filter_accountable
    
    if params[:order] == 'last'
      @service_requests = @service_requests.order(:id => 'DESC')
    elsif params[:order] == 'oldest'
      @service_requests = @service_requests.order(:id => 'ASC')
    elsif params[:order] == 'asc'
      @service_requests = @service_requests.order(:title => params[:order])
    elsif params[:order] == 'desc'  
      @service_requests = @service_requests.order(:title => params[:order])
    else
      @service_requests = @service_requests.order(:id => 'DESC')
    end

    if current_user.admin?  || current_user.collaborator?
      if params[:responsible].present? && params[:responsible] != 'all'
        @service_requests = @service_requests.my_responsability params[:responsible]
        @filter_responsible = User.find params[:responsible]
      end
    elsif current_user.board_member? && params[:responsible] != 'all'
      @service_requests = @service_requests.is_board_member current_user
    else
    end

    @service_requests = @service_requests.paginate(page: params[:page], per_page: ServiceRequest::PER_PAGE)
    
    @company = current_user.company
    @open_tab = 'active'
    load_more_at_bottom
  end

  def closed
    params[:order] ||= 'last'
    group_building = current_user.my_company.buildings
    add_company = 'Company-' + current_user.my_company.id.to_s
    @contacts_by_accountable = [];
    qty_company = 0
    @service_requests.open.with_read_marks_for(current_user).includes(:user, :responsible, comments: [:commentable, :user]).each do |service|
      service_accountable = service.user.accountable.class.name + '-' + service.user.accountable.id.to_s
      if add_company == service_accountable
        qty_company += 1
      end
    end
    @contacts_by_accountable.push(add_company => qty_company)

    group_building.each do |building|
      add_building = 'Building-' + building[:id].to_s
      qty = 0
      @service_requests.open.with_read_marks_for(current_user).includes(:user, :responsible, comments: [:commentable, :user]).each do |service|
        service_accountable = service.user.accountable.class.name + '-' + service.user.accountable.id.to_s
        if add_building == service_accountable
          qty += 1
        end

      end 
      @contacts_by_accountable.push(add_building => qty)
    end
    
  
    @total_invites = 0
    @contacts_by_accountable.each do |invites|
      invites.each do |invite, value|
        @total_invites += value
      end
    end

    filter_accountable

    if params[:order] == 'last'
      @service_requests = @service_requests.order(:id => 'DESC')
    elsif params[:order] == 'oldest'
      @service_requests = @service_requests.order(:id => 'ASC')
    elsif params[:order] == 'asc'
      @service_requests = @service_requests.order(:title => params[:order])
    elsif params[:order] == 'desc'  
      @service_requests = @service_requests.order(:title => params[:order])
    else
      @service_requests = @service_requests.order(:id => 'DESC')
    end
    
    @service_requests = @service_requests.closed.with_read_marks_for(current_user).paginate(page: params[:page], per_page: ServiceRequest::PER_PAGE)
    @closed_tab = 'active'
    load_more_at_bottom
  end

  def new
    render "residents/service_requests/new"
  end

  def create
    @service_request.user = current_user if @service_request.publisher.nil?
    @service_request.save
    render 'residents/service_requests/create'
  end

  def destroy
    @service_request.destroy
    
    redirect_to service_requests_url
  end

  def change_status
    @service_request.update status: params[:status]
    create_comment t('service_requests.change_status', status: @service_request.status_translation)
    render 'residents/service_requests/update_field'
  end

  def change_responsible
    @service_request.update responsible_id: params[:responsible_id], responsible_type: 'User'
    create_comment t('service_requests.change_responsible', responsible: @service_request.responsible_name)
    
    UserMailer.change_responsible_service_request(@service_request, @service_request.responsible).deliver_later
    
    render 'residents/service_requests/update_field'
  end

  def mark_as_read
    @service_request.mark_as_read! for: current_user
    render "residents/service_requests/mark_as_read"
  end

  def search
    group_building = current_user.my_company.buildings
    add_company = 'Company-' + current_user.my_company.id.to_s
    @contacts_by_accountable = [];
    qty_company = 0
    tmp = @service_requests
    @service_requests.open.with_read_marks_for(current_user).includes(:user, :responsible, comments: [:commentable, :user]).each do |service|
      service_accountable = service.user.accountable.class.name + '-' + service.user.accountable.id.to_s
      if add_company == service_accountable
        qty_company += 1
      end
    end
    @contacts_by_accountable.push(add_company => qty_company)

    group_building.each do |building|
      add_building = 'Building-' + building[:id].to_s
      qty = 0
      @service_requests.open.with_read_marks_for(current_user).includes(:user, :responsible, comments: [:commentable, :user]).each do |service|
        service_accountable = service.user.accountable.class.name + '-' + service.user.accountable.id.to_s
        if add_building == service_accountable
          qty += 1
        end

      end 
      @contacts_by_accountable.push(add_building => qty)
    end
    
  
    @total_invites = 0
    @contacts_by_accountable.each do |invites|
      invites.each do |invite, value|
        @total_invites += value
      end
    end
    @service_requests = @service_requests.search_in_ticket(params[:query]).with_read_marks_for(current_user).paginate(page: params[:page], per_page: ServiceRequest::PER_PAGE)
    filter_accountable
    load_more_at_bottom_respond_to @service_requests, html: 'residents/service_requests/search_results',
    partial: 'residents/service_requests/service_request'
  end

  def rank
    @service_request.update rate_score: params[:score]
    render 'residents/service_requests/update_field'
  end

  def selectable_publishers
    render json: admins_and_residents_for_select2
  end

  def export
    params[:days] ||= 30
    report_date = Date.current() - params[:days].to_i
    filter_accountable
    @service_requests = @service_requests.where('service_requests.created_at >= ?', report_date)
    
    respond_to do |format|
      format.html
      format.csv { send_data @service_requests.to_csv, filename: "report-request-#{Date.today}.csv" }
    end
  end

private

  def service_request_params
    params.require(:service_request).permit(:user_id, :responsible_id, :responsible_type, :title, :content, :rate_score, :urgent, :category,
      attachments_attributes: [:id, :attachmentable_type, :attachmentable_id, :file_attachment, :_destroy]
    )
  end

  def create_comment(content)
    Comment.create user_id: current_user.id, commentable_type: @service_request.class.name, commentable_id: @service_request.id,
      content: content
  end

  def load_more_at_bottom
    load_more_at_bottom_respond_to @service_requests, html: 'residents/service_requests/index', partial: 'residents/service_requests/service_request'
  end

  def publisher_json_builder(user, attr_name)
    if user.class.name == 'User' || user.class.name == 'Admin'
      { 
        id: user.id,
        text: user.try(attr_name),
        logo: ActionController::Base.helpers.asset_path(user.logo.url :square),
        letter: user.first_name_letter,
        apartment_numbers: user.contact_details.apartment_numbers.join(" - "), 
        accountable: user.accountable.name  
      }
    else
      { 
        id: user.id,
        text: user.try(attr_name),
        logo: ActionController::Base.helpers.asset_path(user.logo.url :square),
        letter: user.first_name_letter,
        apartment_numbers: user.contact_details.apartment_numbers.join(" - "), 
        accountable: user.accountable.name  
      } 
    end
  end

  def admins_and_residents_for_select2
    if params[:query].present?
      admins = current_user.accountable.admins.search_by(params[:query]).map { |u| publisher_json_builder(u, :full_name) }
      residents = current_user.accountable.users.search_by(params[:query]).map { |u| publisher_json_builder(u, :full_name) }
      
      group_admins = admins.present? ? [text: t('roles.admins').concat(' :')] + admins : []
      group_residents = residents.present? ? [text: t('roles.residents').concat(' :')] + residents : []
      
      group_admins + group_residents
    end
  end

  def filter_accountable
    @param_building = params[:b] if params[:b].present?
    @param_company = params[:c] if params[:c].present?
    
    if @param_building
      @service_requests = @service_requests.joins(:user).where("users.accountable_id = #{@param_building}")
    end
    if @param_company
      @service_requests = @service_requests.joins(:user).where("users.accountable_id = #{@param_company}")
    end
    @service_requests.each do |request|
      puts request.to_json
    end
    
  end

end
