class ImagesController < ApplicationController

  def create
    @image = Image.new image_params
    @image.save
    @new_image = true
    render 'set_as_cover'
  end

  def create_multiple
    @images = []
    params[:images].each do |image|
      @images << Image.create(image_params.merge image: image)
    end
  end

  def set_as_cover
    @image = Image.find params[:id]
    @image.update home: true
  end

  def destroy
    @image = Image.find params[:id]
    @image.destroy
  end

private

  def image_params
    params.require(:image).permit :imageable_type, :imageable_id, :image, :home
  end

end
