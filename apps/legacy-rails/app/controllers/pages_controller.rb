class PagesController < ApplicationController

  COMPANY_PUBLIC_ACTIONS = %w[company company_communities company_photos company_reviews company_about company_settings]
  BUILDING_PUBLIC_ACTIONS = %w[building building_about building_reviews building_photos building_settings]
  BUSINESS_PUBLIC_ACTIONS = %w[business business_about business_offers business_reviews business_photos]

  skip_before_action :authenticate_user!
  # skip_before_action :check_registration_finished

  before_action :set_company, only: COMPANY_PUBLIC_ACTIONS
  before_action :set_building, only: BUILDING_PUBLIC_ACTIONS
  before_action :set_business, only: BUSINESS_PUBLIC_ACTIONS
  before_action :set_maps, only: BUILDING_PUBLIC_ACTIONS + COMPANY_PUBLIC_ACTIONS + BUSINESS_PUBLIC_ACTIONS
  before_action :redirect_page, only: [:privacy, :terms]

  def index
    if user_signed_in?
      redirect_to user_dashboard
    elsif Rails.env.production?
      redirect_to 'https://communities.condo-media.com'
    else
      render 'index', layout: false
    end
  end

  def welcome
    @user = User.find_by_id params[:user]
    if @user
      render :welcome, layout: 'devise'
    else
      redirect_to root_path
    end
  end

  def social_login
    render 'devise/sessions/social_login', layout: 'devise'
  end

  # COMPANY PUBLIC PAGES:

  def company
    @comments = @company.news_feed_posts(current_user).filtered_for(current_user, params[:filter]).includes(:comments, :user, :attachments)
    @comments = set_pagination @comments, Comment::COMPANY_PER_PAGE
    load_more_at_bottom_respond_to @comments, html: 'pages/companies/index', partial: 'comments/timeline_comment'
  end

  def company_communities
    render 'pages/companies/communities'
  end

  def company_reviews
    render 'pages/companies/reviews'
  end

  def company_photos
    render 'pages/companies/photos'
  end

  def company_about
    render 'pages/companies/about'
  end

  def company_settings
    render 'pages/companies/settings'
  end

  # BUILDING PUBLIC PAGES:

  def building
    @comments = @building.news_feed_posts(current_user).filtered_for(current_user, params[:filter]).includes(:comments, :user, :attachments)
    @comments = set_pagination @comments, Comment::BUILDING_PER_PAGE
    load_more_at_bottom_respond_to @comments, html: 'pages/buildings/index', partial: 'comments/timeline_comment'
  end

  def building_about
    render 'pages/buildings/about'
  end

  def building_reviews
    render 'pages/buildings/reviews'
  end

  def building_photos
    render 'pages/buildings/photos'
  end

  def building_settings
    render 'pages/buildings/settings'
  end

  # BUSINESS PUBLIC PAGES:

  def business
    @comments = set_pagination @business.comments, Comment::BUSINESS_PER_PAGE
    load_more_at_bottom_respond_to @comments, html: 'pages/businesses/index', partial: 'comments/timeline_comment'
  end

  def business_about
    render 'pages/businesses/about'
  end

  def business_offers
    render 'pages/businesses/offers'
  end

  def business_reviews
    render 'pages/businesses/reviews'
  end

  def business_photos
    render 'pages/businesses/photos'
  end

  def change_language
    if params[:lang]
      I18n.locale = params[:lang]
      if current_user
        current_user.update locale: params[:lang]
      else
        session[:lang] = params[:lang]
      end
    end
    if request.env["HTTP_REFERER"]
      redirect_to :back
    else
      redirect_to root_path
    end
  end

  def privacy
  end

  def terms
  end

private

  def set_company
    @company = Company.find_by(namespace: (params[:namespace] || params[:company_namespace]))
    @links = [{name: t('profiles.timeline'), path: company_root_path(@company)}]
    @links << {name: t('profiles.about'), path: company_public_about_path(@company)} if can?(:see_contact_information, @company)
    @links += [{name: t('profiles.photos'), path: company_public_photos_path(@company), class: 'hidden-xs'},
      {name: t('profiles.reviews'), path: company_public_reviews_path(@company), class: 'hidden-xs'}]
    @links << {name: t('profiles.settings'), path: company_public_settings_path(@company), class: 'hidden-xs'} if can?(:company_settings, @company)
    validates_model_object @company
  end

  def set_building
    @building = current_building
    @links = [{name: t('profiles.timeline'), path: building_root_path}]
    @links << {name: t('profiles.about'), path: building_about_path} if can?(:see_contact_information, @building)
    @links += [{name: t('profiles.photos'), path: building_photos_path(@company), class: 'hidden-xs'},
      {name: t('profiles.reviews'), path: building_reviews_path, class: 'hidden-xs'}]
    @links << {name: t('profiles.settings'), path: building_settings_path, class: 'hidden-xs'} if can?(:building_settings, @building)

    validates_model_object @building
  end

  def set_business
    @business = Business.find_by namespace: (params[:namespace] || params[:business_namespace])
    @links = [
      {name: t('profiles.timeline'), path: business_root_path(@business)},
      {name: t('profiles.about'), path: business_public_about_path(@business)},
      {name: t('profiles.offers'), path: business_public_offers_path(@business), class: 'hidden-xs'},
      {name: t('profiles.reviews'), path: business_public_reviews_path(@business), class: 'hidden-xs'},
      {name: t('profiles.photos'), path: business_public_photos_path(@business), class: 'hidden-xs'}
    ]
    validates_model_object @business
  end

  def set_maps
    @show_map = true
  end

  def validates_model_object(model_object)
    unless model_object
      flash[:error] = t('general.page_not_exist')
      redirect_to root_path
    end
  end

  def redirect_page
    redirect_to "https://communities.condo-media.com#{request.fullpath}"
  end

end
