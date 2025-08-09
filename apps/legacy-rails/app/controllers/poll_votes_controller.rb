class PollVotesController < ApplicationController

  load_and_authorize_resource

  def create
    @poll_vote.save
  end

  def update
    @poll_vote.update_attributes update_params
  end

private

  def create_params
    params.require(:poll_vote).permit(:poll_id, :poll_answer_id).merge user_id: current_user.id
  end

  def update_params
    params.require(:poll_vote).permit(:poll_answer_id)
  end

end
