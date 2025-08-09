class CommentsController < ApplicationController

  include MarkableCalls
  
  load_and_authorize_resource
  skip_authorize_resource :only => :load_timeline_comment

  def load_timeline_comment
    data = params[:data_comment].split('-')
    
    if data.count > 1
      case data[0]
      when 'comment'
        commentable = Comment.find(data[1]) 
      when 'message'
        commentable = Message.find(data[1]) 
      when 'service_request'
        commentable = ServiceRequest.find(data[1]) 
      when 'event'
        commentable = Event.find(data[1]) 
      when 'reservation'
        commentable = Reservation.find(data[1]) 
      when 'classified'
        commentable = Classified.find(data[1])         
      else
        abort 'else case commentable'
      end
    end
    render commentable.comments.order(created_at: :desc)
  end

  def create
    @comment.save
    render 'comments/create_timeline_comment' if %w[Company User Building Business].include? @comment.commentable_type
  end

  def destroy
    @comment.destroy
  end

  def toggle_report
    toggle_mark_for @comment, 'reported'
  end

  def toggle_hide
    toggle_mark_for @comment, 'hidden'
  end

private

  def comment_params
    params.require(:comment).permit( :commentable_type, :commentable_id, :content, :recipient_id, :recipient_type,
      attachments_attributes: [:id, :attachmentable_type, :attachmentable_id, :file_attachment, :_destroy]
    ).merge!(user_id: current_user.id)
  end

end
