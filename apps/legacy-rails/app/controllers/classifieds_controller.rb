class ClassifiedsController < ApplicationController

  include MarkableCalls
  load_and_authorize_resource

  def index
    params[:order] ||= 'last'

    
    @classifieds = @classifieds.filtered_for(current_user, params[:filter])
    @classifieds = @classifieds.includes(:publisher, :attachments, comments: :attachments).paginate(page: params[:page], per_page: Classified::PER_PAGE)
    if params[:order] == 'last'
      @classifieds = @classifieds.order(:id => 'DESC')
    elsif params[:order] == 'oldest'
      @classifieds = @classifieds.order(:id => 'ASC')
    else
      @classifieds = @classifieds.order(:title => params[:order].to_sym)
    end
    load_more_at_bottom_respond_to @classifieds
  end

  def create
    @classified.publisher = current_user if @classified.publisher.nil?
    @classified.save
  end

  def edit
  end

  def update
  end

  def destroy
    @classified.destroy
  end

  def search
    @classifieds = set_pagination @classifieds.search_by(params[:query]).includes(:publisher, :attachments, comments: :attachments),
      Classified::PER_PAGE
    load_more_at_bottom_respond_to @classifieds
  end

  def toggle_save
    toggle_mark_for(@classified, 'saved')
  end

  def toggle_hide
    toggle_mark_for(@classified, 'hidden')
  end

  def toggle_report
    toggle_mark_for(@classified, 'reported')
  end

private

  def classified_params
    params.require(:classified).permit(:title, :description, :price, :recipient_id, :recipient_type, :publisher_id,
      attachments_attributes: [:id, :attachmentable_type, :attachmentable_id, :file_attachment, :_destroy]
    )
  end

end
