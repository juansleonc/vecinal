class MessagesController < ApplicationController

  include Select2able

  load_and_authorize_resource
  skip_load_resource only: :empty_trash
  skip_before_action :authenticate_user!, only: :notify_email_read

  def index
    params[:order] ||= 'last'
    
    @inbox_tab = 'active'
    @messages = @messages.inbox_for(current_user).with_read_marks_for(current_user)
    
    prepare_messages
    load_more_at_bottom
  end

  def sort_by_status
    params[:status] ||= 'all'
    case params[:status]
      when 'unread'
      when 'urgent'
        @messages = @messages.where(urgent: true)
      when 'warning'
        @messages = @messages.where(warning: true)
      else
      
    end
  end
  def prepare_messages
    sort_by
    sort_by_status
    @messages = @messages.paginate(page: params[:page], per_page: Message::PER_PAGE)
  end
  def sort_by
    if params[:order] == 'last'
      @messages = @messages.order(:id => 'DESC')
    elsif params[:order] == 'oldest'
      @messages = @messages.order(:id => 'ASC')
    else
      @messages = @messages.order(:title => params[:order].to_sym)
    end
  end

  def new
    @to_contact = current_user.contacts.find_by_id(params[:to_contact]) if params[:to_contact].present?
    render 'residents/messages/new'
  end

  def trash
    params[:order] ||= 'last'
    @trash_tab = 'active'
    @empty_trash = true
    @messages = @messages.marked(current_user, 'deleted').with_read_marks_for(current_user)

    prepare_messages
    load_more_at_bottom
  end

  def done
    params[:order] ||= 'last'
    @done_tab = 'active'
    @messages = @messages.marked(current_user, 'done').with_read_marks_for(current_user)

    prepare_messages

    load_more_at_bottom
  end

  def selection_changed_user
    render 'residents/messages/selection_changed_user'
  end

  def selection_changed_company
    @company = current_user.accountable if current_user.accountable.is_a?(Company)
    render 'residents/messages/selection_changed_company'
  end

  def selection_changed_building
    @buildings = current_user.buildings
    render 'residents/messages/selection_changed_building'
  end

  def create
    @message.save
    render 'residents/messages/create'
  end

  def destroy
    @message.destroy
    redirect_to messages_path
  end

  def mark_as_read
    @message.mark_as_read! for: current_user
    #@message.mark! current_user, 'email_read'
    #render "residents/messages/mark_as_read"
    render :nothing => true, :status => :ok
  end

  def mark_as_unread
    @message.read_marks.where(reader: current_user).delete_all
    render "residents/messages/mark_as_unread"
  end

  def mark_as_deleted
    @message.clear_marks_for(current_user)
    @message.mark!(current_user, 'deleted')
    render "residents/messages/mark_as_deleted"
  end

  def mark_as_done
    @message.clear_marks_for(current_user)
    @message.mark!(current_user, 'done')
    render "residents/messages/mark_as_done"
  end

  def mark_as_destroyed
    @message.clear_marks_for(current_user)
    @message.mark!(current_user, 'destroyed')
    render "residents/messages/mark_as_destroyed"
  end

  def move_to_inbox
    @message.clear_marks_for(current_user)
    render "residents/messages/mark_as_done"
  end


  def notify_email_read
    user = User.find params[:user_id]
    # Message.find(params[:message_id]).mark! user, 'email_read'
    Message.find(params[:message_id]).mark_as_read! for: user
    render nothing: true, status: :ok, content_type: 'text/html'
  end

  def empty_trash
    @messages = Message.marked(current_user, 'deleted')
    @messages.each do |message|
      message.clear_marks_for(current_user)
      message.mark!(current_user, 'destroyed')
    end
    render 'residents/messages/empty_trash'
  end

  def search
    @messages = set_pagination @messages.not_marked_as('destroyed').search_by(params[:query]).with_read_marks_for(current_user), Message::PER_PAGE
    load_more_at_bottom_respond_to @messages, html: 'residents/messages/search_results', partial: 'residents/messages/message'
  end

  def admins_and_residents
  end

private

=begin
  def message_params
    params.require(:message).permit(:title, :content, :urgent, :notify_user, :add_to_sticky_notes,
      :receiver_type, { receivers: [] },
      attachments_attributes: [:id, :attachmentable_type, :attachmentable_id, :file_attachment, :_destroy]
    ).merge! sender_id: current_user.id
  end
=end

  def message_params
    params.require(:message).permit(:title, :content, :urgent, :warning, { receivers: [] },
      attachments_attributes: [:id, :attachmentable_type, :attachmentable_id, :file_attachment, :_destroy]
    ).merge! sender_id: current_user.id
  end

  def load_more_at_bottom
    load_more_at_bottom_respond_to @messages, html: 'residents/messages/index', partial: 'residents/messages/message'
  end

end
