class ApartmentsController < CompaniesController
  before_action :set_apartment, only: [:show, :edit, :update, :destroy]

  def index
    @apartments = @company.apartments
  end

  def show
  end

  def new
    @apartment = Apartment.new
  end

  def edit
  end

  def create
    @apartment = Apartment.new(images_processed_params(apartment_params))
    if saved = @apartment.save
      process_images(@apartment, saved)
      redirect_to company_public_apartments_path(@company)
    else
      @apartment.images.each { |image| image.save }
      process_images(@apartment, saved)
      render 'new'
    end
  end

  def update
    if @apartment.update(apartment_params)
      redirect_to company_public_apartments_path(@company)
    else
      @apartment.images.each { |image| image.save }
      render 'edit'
    end
  end

  def destroy
    @apartment.destroy
    redirect_to company_public_apartments_path(@company)
  end

  private
    def set_apartment
      @apartment = @company.apartments.find(params[:id])
    end

    def apartment_params
      params.require(:apartment).permit(
        :building_id, :apartment_numbers, :category, :available_at, :show_price, :price, :size_ft2, :bedrooms,
        :bathrooms, :furnished, :pets, :show_contact, :secondary_phone_number, :secondary_email, :title, :description,
        images_attributes: [:id, :image, :home, :_destroy]
      )
    end

end
