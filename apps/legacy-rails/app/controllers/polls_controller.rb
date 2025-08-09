class PollsController < ApplicationController
  include MarkableCalls
  load_and_authorize_resource

  def index
    @buildings = current_user.buildings
    @polls = @polls.filtered_for(current_user, params[:filter])


    group_building = current_user.my_company.buildings
    add_company = 'Company-' + current_user.my_company.id.to_s
    @contacts_by_accountable = [];
    qty_company = 0
    @polls.includes(:publisher, :attachments).each do |poll|
      accountable_poll = poll.user.accountable.class.name + '-' + poll.user.accountable.id.to_s
      if add_company == accountable_poll
        qty_company += 1
      end
    end
    @contacts_by_accountable.push(add_company => qty_company)
    group_building.each do |building|
      add_building = 'Building-' + building[:id].to_s
      qty = 0
      @polls.includes(:publisher, :attachments).each do |poll|
        accountable_poll = poll.user.accountable.class.name + '-' + poll.user.accountable.id.to_s
        if add_building == accountable_poll
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

    @polls = @polls.includes(:publisher, :attachments)
    @param_building = params[:b] if params[:b].present?
    @param_company = params[:c] if params[:c].present?
    
    if @param_building
      @polls = @polls.joins(:publisher).where("accountable_id = #{@param_building}")
    end

    if @param_company
      @polls = @polls.joins(:publisher).where("accountable_id = #{@param_company}")
    end

    @polls = @polls.paginate(page: params[:page], per_page: Poll::PER_PAGE)
    load_more_at_bottom_respond_to @polls
  end

  def create
    @poll.save
  end

  def destroy
    @poll.destroy
  end

  def search
    @polls = set_pagination @polls.search_by(params[:query]).includes(:publisher, :attachments), Poll::PER_PAGE
    load_more_at_bottom_respond_to @polls
  end

  def toggle_save
    toggle_mark_for @poll, 'saved'
  end

  def toggle_hide
    toggle_mark_for @poll, 'hidden'
  end

  def toggle_report
    toggle_mark_for @poll, 'reported'
  end

private

  def create_params
    params.require(:poll).permit(:question, :days_or_date, :duration, :end_date_date, :recipient_type, :recipient_id,
      poll_answers_attributes: [:name],
      attachments_attributes: [:id, :attachmentable_type, :attachmentable_id, :file_attachment, :_destroy]
    ).merge publisher_id: current_user.id
  end

end
