class EventsController < ApplicationController

  include MarkableCalls
  include Select2able

  load_resource except: :calendar
  authorize_resource
  before_action :clear_marks, only: [:mark_as_acknowledged, :mark_as_yes, :mark_as_no, :mark_as_maybe]
  before_action :categor_filter, only: [:index, :past]
  def index
    @upcoming_tab = 'active'
    params[:order] = 'asc'
    @user_decorator = UserDecorator.new(current_user)

    group_building = current_user.my_company.buildings
    add_company = 'Company-' + current_user.my_company.id.to_s
    @contacts_by_accountable = [];
    qty_company = 0
    @events.upcoming.includes(sender: :accountable, comments: :attachments).each do |event|
      accountable_event = event.user.accountable.class.name + '-' + event.user.accountable.id.to_s
      if add_company == accountable_event
        qty_company += 1
      end
    end
    @contacts_by_accountable.push(add_company => qty_company)

    group_building.each do |building|
      add_building = 'Building-' + building[:id].to_s
      qty = 0
      @events.upcoming.includes(sender: :accountable, comments: :attachments).each do |event|
        accountable_event = event.user.accountable.class.name + '-' + event.user.accountable.id.to_s
        if add_building == accountable_event
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

    @events = @events.upcoming.includes(sender: :accountable, comments: :attachments).order(:date)
    
    @param_building = params[:b] if params[:b].present?
    @param_company = params[:c] if params[:c].present?
    

    if @param_building
      @events = @events.joins(:sender).where("users.accountable_id = #{@param_building}")
    end

    if @param_company
      @events = @events.joins(:sender).where("users.accountable_id = #{@param_company}")
    end
    @uri_path = request.path.slice 1 .. request.path.length

    

    @events = @events.paginate(page: params[:page], per_page: Event::PER_PAGE)
    load_more_at_bottom_respond_to @events, html: 'residents/events/index', partial: 'residents/events/event'
  end

  def categor_filter
    params[:category] ||= 'all'

    if params[:category] == 'saved'
      @events = @events.marked_with(current_user, ['saved'])
    elsif params[:category] == 'hidden'
      @events = @events.marked_with(current_user, ['hidden'])
    elsif params[:category] == 'reported'
      @events = @events.reported_marks_for(current_user)
    end
  end

  def past
    @uri_path = request.path.slice 1 .. request.path.length
   

    @past_tab = 'active'
    group_building = current_user.my_company.buildings
    add_company = 'Company-' + current_user.my_company.id.to_s
    @contacts_by_accountable = [];
    qty_company = 0
    @events.past.order(:date).each do |event|
      accountable_event = event.user.accountable.class.name + '-' + event.user.accountable.id.to_s
      if add_company == accountable_event
        qty_company += 1
      end
    end
    @contacts_by_accountable.push(add_company => qty_company)

    group_building.each do |building|
      add_building = 'Building-' + building[:id].to_s
      qty = 0
      @events.past.order(:date).each do |event|
        accountable_event = event.user.accountable.class.name + '-' + event.user.accountable.id.to_s
        if add_building == accountable_event
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

    @events =  @events.past.order(:date)
    
    @param_building = params[:b] if params[:b].present?
    @param_company = params[:c] if params[:c].present?
    if @param_building
      @events = @events.joins(:sender).where("users.accountable_id = #{@param_building}")
    end

    if @param_company
      @events = @events.joins(:sender).where("users.accountable_id = #{@param_company}")
    end
    

    @events = @events.paginate(page: params[:page], per_page: Event::PER_PAGE)

    load_more_at_bottom_respond_to @events, html: 'residents/events/index', partial: 'residents/events/event'
  end

  def calendar
    @date = Time.parse params[:month]
    render 'residents/events/calendar'
  end

  def selection_changed_user
    render 'residents/events/selection_changed_user'
  end

  def selection_changed_company
    @company = current_user.accountable if current_user.accountable.is_a?(Company)
    render 'residents/events/selection_changed_company'
  end

  def selection_changed_building
    @buildings = current_user.buildings
    render 'residents/events/selection_changed_building'
  end

  def create
    @event.save
    render 'residents/events/create'
  end

  def mark_as_acknowledged
    @event.mark!(current_user, 'acknowledged')
    render "residents/events/mark"
  end

  def mark_as_yes
    @event.mark!(current_user, 'yes')
    render "residents/events/mark"
  end

  def mark_as_no
    @event.mark!(current_user, 'no')
    render "residents/events/mark"
  end

  def mark_as_maybe
    @event.mark!(current_user, 'maybe')
    render "residents/events/mark"
  end

  def destroy
    @event.destroy
    render "residents/events/destroy"
  end

  def search
    params[:order] = 'asc'
    @events = set_pagination @events.search_by(params[:query]).includes(sender: :accountable, comments: :attachments),
      Event::PER_PAGE, order_by: :date
    load_more_at_bottom_respond_to @events, html: 'residents/events/search', partial: 'residents/events/event'
  end

  def toggle_save
    toggle_mark_for @event, 'saved'
  end

  def toggle_hide
    toggle_mark_for @event, 'hidden'
  end

  def toggle_report
    toggle_mark_for @event, 'reported'
  end

private

  def event_params
    params.require(:event).permit( :title, :date, :time_to, :time_from, :location, :rsvp, :details, { :receivers => [] },
      attachments_attributes: [:id, :attachmentable_type, :attachmentable_id, :file_attachment, :_destroy]
    ).merge! sender_id: current_user.id
  end

  def clear_marks
    @event.clear_marks_for(current_user)
  end
end
