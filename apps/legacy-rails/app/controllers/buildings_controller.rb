class BuildingsController < CompaniesController
  before_action :set_building, except: [:index, :new, :create]
  before_action :order_by, only: :index
  def order_by
    params[:order] ||= 'asc'
    if params[:order].empty?
      params[:order] = 'asc'
    end
  end

  def index
    #@buildings = set_pagination @company.buildings, Building::PER_PAGE
    if params[:order] == 'last'
      @buildings = @company.buildings.order(:id => 'DESC').paginate(page: params[:page], per_page: Building::PER_PAGE)
    elsif params[:order] == 'oldest'
      @buildings = @company.buildings.order(:id => 'ASC').paginate(page: params[:page], per_page: Building::PER_PAGE)      
    else
      @buildings = @company.buildings.order(:name => params[:order].to_sym).paginate(page: params[:page], per_page: Building::PER_PAGE)
    end
    @action_for_search = building_search_path(current_user.accountable, query: params[:query], responsible: params[:responsible], order: params[:order], b: params[:b], c: params[:c]) 
    
    @order = %w[asc desc last oldest].include?(params[:order]) ? params[:order].to_sym : :desc
    @total = @buildings.count
    load_more_at_bottom_respond_to @buildings
  end
  
  def search
    @buildings = set_pagination @company.buildings.search_by(params[:query]), Building::PER_PAGE
    
    @submenu_title = 'Search'
    @action_for_search = building_search_path(current_user.accountable, query: params[:query], responsible: params[:responsible], order: params[:order], b: params[:b], c: params[:c])
    load_more_at_bottom_respond_to @buildings
  end

  def show
  end

  def new
    @building = @company.buildings.build
  end

  def edit
  end

  def create
    @building = @company.buildings.build(building_params)
    @building.save
  end

  def update
    if @building.update(building_params)
      redirect_to building_about_url(subdomain: @building)
    else
      @building.images.each { |image| image.save }
      flash[:error] = @building.errors.full_messages.join(', ')
      redirect_to building_about_url(subdomain: @building)
    end
  end

  def destroy
    @building.secure_destroy(destroy_params)
    flash[:notice] = "Building destroyed" if @building.destroyed?
  end

  def update_logo
    logo = params[:destroy] ? nil : params[:building][:logo]
    @building.update logo: logo
    redirect_to :back
  end

  def update_settings
    new_admin_default_requests = params[:setting][:admin_default_requests];
    
    if @building.admin_default_requests != new_admin_default_requests
      @building.admin_default_requests = new_admin_default_requests
      @building.save
    end

    new_admin_default_reservations = params[:setting][:admin_default_reservations];
    
    if @building.admin_default_reservations != new_admin_default_reservations
      @building.admin_default_reservations = new_admin_default_reservations
      @building.save
    end
   
    @building.update_settings settings_params
    redirect_to building_settings_url(subdomain: @building)
  end

private

  def set_building
    @building = @company.buildings.find_by subdomain: params[:building_subdomain]
  end

  def building_params
    params.require(:building).permit(
      :name, :subdomain, :description, :size, :category, :address, :city, :region, :country, :zip, :logo, :remove_logo, :email, :phone,
      :website, :opening_hours, :community_id, :managed_by, :billing_information, images_attributes: [:id, :image, :home, :_destroy]
    )
  end

  def destroy_params
    params.permit(:password).merge(user: current_user)
  end

  def settings_params
    params
      .require(:setting)
      .permit(*(SettingableCommunity::NOTIFICATIONS + SettingableCommunity::PROFILE))
  end

end