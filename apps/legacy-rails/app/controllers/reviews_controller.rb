class ReviewsController < ApplicationController

  include MarkableCalls
  load_and_authorize_resource

  def create
    @review.save
  end

  def destroy
    @review.destroy
  end

  def toggle_report
    toggle_mark_for @review, 'reported'
  end

  def toggle_hide
    toggle_mark_for @review, 'hidden'
  end

private

  def review_params
    params.require(:review).permit(:rank, :comment, :reviewable_type, :reviewable_id,
      attachments_attributes: [:id, :attachmentable_type, :attachmentable_id, :file_attachment, :_destroy]
    ).merge user: current_user
  end

end
