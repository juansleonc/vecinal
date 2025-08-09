class LikesController < ApplicationController

  load_and_authorize_resource

  def toggle
    @like = Like.find_or_initialize_by user: current_user, likeable_type: params[:likeable_type], likeable_id: params[:likeable_id]
    if @like.persisted?
      @like.destroy
    else
      @like.save
    end
  end

end
