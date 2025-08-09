class ResidentsController < ApplicationController
  include MarkableCalls
  before_action :get_members_roles
  before_action :get_administrative_roles
  before_action :set_contacts, only: [:contacts, :search_contacts, :reported_contacts]

  def news_feed
    params[:filter] ||= 'all'
    @comments = current_user.news_feed_posts
      .includes(:attachments, comments: :attachments)
      .not_personal
      .filtered_for(current_user, params[:filter], false)
    @comments_by_filter = @comments
    list_communities = []
    @comments_by_filter.each do |comment|
      comment.shares.each do |share|
        list_communities.push(share.recipientable_type + "-" + share.recipientable_id.to_s)
      end
    end
    
    @contacts_by_accountable = [];
    @total_invites = 0
    current_user.my_company.buildings.each do |building|
      qty = 0
      add_building = 'Building-' + building[:id].to_s
      list_communities.each do |accountable|
        if accountable == add_building
          qty += 1
        end
      end
      @total_invites += qty
      @contacts_by_accountable.push(add_building => qty)
    end

    building = Building.find params[:b] if params[:b].present?
    if building
      @comments = @comments.by_shared(building)
    end
    @comments = set_pagination @comments, Comment::USER_PER_PAGE
    load_more_at_bottom_respond_to @comments, partial: 'comments/timeline_comment'
  end

  

  def contacts
    params[:order] ||= 'asc'
    
    
    if params[:order] == 'last'
      @contacts = @contacts.order(:id => 'DESC')
    elsif params[:order] == 'oldest'
      @contacts = @contacts.order(:id => 'ASC')
    else
      @contacts = @contacts.order(:first_name => params[:order].to_sym)
    end

    case params[:status]
    when 'confirmed'
      @contacts = @contacts.where.not(confirmed_at: nil)  
    when 'unconfirmed'
      @contacts = @contacts.where(confirmed_at: nil)  
    end

    #contact.confirmed_at.present?  
    @contacts = @contacts.paginate(page: params[:page], per_page: User::CONTACTS_PER_PAGE)
    
    @total = @contacts.count
    @order = %w[asc desc].include?(params[:order]) ? params[:order].to_sym : :desc
    @submenu_title = t 'contacts.title'
    @submenu_item = 'people'
    @param_building = params[:b] if params[:b].present?
    @param_company = params[:c] if params[:c].present?
    
    @action_for_search = search_contacts_path(query: params[:query], responsible: params[:responsible], order: params[:order], b: params[:b], c: params[:c])
    
    load_more_at_bottom_respond_to @contacts, html: 'residents/contacts/index', partial: 'residents/contacts/contact'
  end

  def communities
    @building = current_building
    @company = @building.company
  end

  def search_news_feed
    #abort current_user.news_feed_posts.search_by(params[:query]).includes(:attachments, comments: :attachments).to_sql
    @comments = set_pagination current_user.news_feed_posts.search_by(params[:query]).includes(:attachments, comments: :attachments),Comment::USER_PER_PAGE
    load_more_at_bottom_respond_to @comments, partial: 'comments/timeline_comment'
  end

  def search_contacts
    params[:order] ||= 'asc'
    @total = @contacts.count
    @contacts = @contacts.search_by(params[:query]).order(:first_name => params[:order].to_sym).paginate(page: params[:page], per_page: User::CONTACTS_PER_PAGE)
    load_more_at_bottom_respond_to @contacts, html: 'residents/contacts/search_results', partial: 'residents/contacts/contact'
  end

  private
    def set_contacts
      @contacts = current_user.contacts
      

      @contacts_by_accountable = current_user.contacts_by_accountable
      @total_invites = 0
      @contacts_by_accountable.each do |invites|
        invites.each do |invite, value|
          @total_invites += value
        end
      end
      @contacts = current_user.contacts(params[:c], params[:b])
    end
    
    def get_members_roles
      @members_roles = [
        {
          :id => 'resident', 
          :name => t('roles.resident')
        },
        {
          :id => 'board_member', 
          :name => t('roles.board_member')
        },
        {
          :id => 'tenant', 
          :name => t('roles.tenant')
        },
        {
          :id => 'agent', 
          :name => t('roles.agent')
        }
        
      ]
    end
  
    def get_administrative_roles
      @administrative_roles = [{:id => 'administrator', :name => t('roles.administrator')},{:id => 'collaborator', :name => t('roles.collaborator')}]
    end
end
