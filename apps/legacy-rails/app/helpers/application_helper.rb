module ApplicationHelper

  def condomedia_form_for(object, options = {}, &block)
    options[:builder] = CondomediaFormBuilder
    form_for(object, options, &block)
  end

  def link_to_add_image(name, f)
    new_object = Image.new
    id = new_object.object_id
    fields = f.fields_for(:images, new_object, child_index: id) do |builder|
      render("images/form", f: builder)
    end
    content_tag :div, class: 'col-xs-12 add-image-grid' do
      link_to(raw('<i class="fa fa-plus"></i> ') + name, '#', id: "add-image-button",
        data: { id: id, fields: fields.gsub("\n", "") }, class: 'btn btn-default'
      )
    end
  end

  def link_to_add_attachment(f)
    new_object = Attachment.new
    id = new_object.object_id
    fields = f.fields_for(:attachments, new_object, child_index: id) do |builder|
      render("attachments/form", f: builder)
    end
    link_to(raw('<i class="fa fa-paperclip"></i> '), '#', class: 'add-attachment-button', data: { id: id, fields: fields.gsub("\n", "") })
  end

  def clean_url(url)
    url.slice! "http://www."
    url.slice! "http://"
    return url
  end

  def condomedia_checkbox(f, attribute, label)
    f.check_box attribute, class: 'awesome-checkbox',
      data: {
        'icon-checked' => 'fa fa-check-circle-o',
        'icon-unchecked' => 'fa fa-circle-o',
        'label-content-checked' => label,
        'label-content-unchecked' => label,
      }
  end

  def url_with_protocol(url)
    /^http/i.match(url) ? url : "http://#{url}"
  end

  def get_markers(geocoded_objects, nested_objects = nil)
    markers = []
    geocoded_objects.each do |object|
      markers << {latitude: object.latitude, longitude: object.longitude,
        html: render(object.map_pop_over_url, object: object, nested_objects: nested_objects) }
    end
    markers.to_json
  end

  def connect_to_stripe(business)
    business_stripe_connect_path(
      business.namespace,
      client_id: Rails.application.secrets.stripe_client_id,
      response_type: 'code',
      scope: 'read_write',
      state: business.namespace,
      stripe_user: {
        email: business.email,
        url: business.website,
        country: business.country,
        phone_number: business.phone,
        business_name: business.name,
        first_name: business.owner.first_name,
        last_name: business.owner.last_name,
        street_address: business.address,
        city: business.city,
        state: business.region,
        zip: business.zip
      }
    )
  end

  def phone_full(phone, extension)
    ext = extension.present? ? " #{t 'general.extension'} #{extension}" : ''
    number_to_phone(phone) + ext
  end

  def confirm_destroy(link_to_destroy, options = {}, text = '')
    method = options[:method] || :delete
    options = {class: 'hidden confirmed-destroy', method: method}.merge options
    link_to('', link_to_destroy, options) +
    link_to('', class: 'confirm-destroy', data: { swal_confirm: t('general.confirm'), swal_confirm_yes: t('general.yes_word'),
      swal_confirm_no: t('general.no_word') }) do
      block_given? ? yield : raw('<i class="fa fa-trash"></i>') + text
    end
  end

  def timeago(date)
    return raw "<span class='timeago'>#{date.strftime '%d/%m/%y'}</span>" if Time.zone.now > (date + 1.week)
    raw "<span class='timeago' title='#{date.getutc.iso8601}'></span>"
  end

  def url_to_home
    return root_path unless current_user
    accountable = current_user.accountable
    return company_root_url(accountable, subdomain: 'www') if accountable.is_a? Company
    return building_root_url(subdomain: accountable) if accountable.is_a? Building
    return business_root_url(accountable, subdomain: 'www') if accountable.is_a? Business
  end

  def cm_popover(title, content = '', options = {})
    options = {toggle: 'popover', trigger: 'hover', placement: 'top'}.merge options
    tags = "data-content='#{content}' title='#{title}'"
    options.each do |tag, val|
      tags << " data-#{tag}='#{val}'"
    end
    raw tags
  end

  def url_full(path_in, subdomain = nil)
    subdomain ||= 'www'
    root_url(subdomain: subdomain).chomp('/') + path_in
  end

  def url_to_edit_accountable(accountable)
    case accountable.class.name
    when 'Company'; edit_company_url(accountable, subdomain: 'www')
    when 'Building'; url_full(edit_company_building_path accountable.company, accountable)
    when 'Business'; edit_business_url(accountable, subdomain: 'www')
    end
  end

  def url_to_profile(community)
    case community.class.name
      when 'Company' then company_root_url(community.namespace)
      when 'Building' then building_root_url(subdomain: community.subdomain)
      when 'Business' then business_root_url(community.namespace)
    end
  end

  def map_images_to_asset_path(images_map)
    images_map_parsed = {}
    images_map.each { |format, image| images_map_parsed[format] = asset_path(image) }
    images_map_parsed
  end

  def finish_registration_communities_path(role=nil)
    role = current_user.role if user_signed_in? && role.nil?
    return finish_registration_buildings_path if role.nil? || role == 'resident' || role == 'board_member' || role == 'tenant'  || role == 'agent'
    return finish_registration_companies_path if role == 'administrator' || role == 'collaborator'
  end

  def shareable_recipient_link(shareable)
    recipient = shareable.recipient
    result = '<span>&bull;</span> <span class="info">' + t('comments.shared_with', with: '')
      result += if %w[Public MyCommunities].include?(recipient.class.name)
        t("general.shareable.#{recipient.name.downcase.gsub(' ', '_')}")
      else
        link_to(recipient.name, recipient.link_to_home(request.base_url))
      end
    result += '</span>'
    result.html_safe
  end

  def recipient_class_id(shareable)
    @contacts_ids ||= current_user_contacts.ids + [current_user.id]
    recipient_class_name = shareable.recipient.class.name
    hidden = ' '
    id = shareable.recipient.id
    if recipient_class_name == 'Public'
      if @contacts_ids.include?(shareable.publisher.id)
        id = '1'
      else
        hidden = ' hidden'
      end
    end
    "#{recipient_class_name}-#{id}#{hidden}"
  end

  def profile_about_input_row(f, field, value, can_update, **options)
    input_given = yield if block_given?
    render 'shared/user_about_row', 
      f: f, field: field,
      value: value,
      can_update: can_update,
      input_given: input_given,
      label: options[:label]
  end

  def random_url_logo_for_letter letter, style = 'square'
    "logos/default_#{rand(0..10)}_#{style}.png"
  end

  def popover_with_content options = { if: true }
    if options[:if]
      content_tag :div, class: "popover-with-content #{options[:class]}", id: options[:id] do
        fa_icon "times"
        yield
      end
    end
  end

  
end

class LinkRenderer < ::WillPaginate::ActionView::LinkRenderer
  protected

  def html_container(html)
    tag :div, tag(:ul, html), container_attributes
  end

  def page_number(page)
    #tag :li, link(page, page, :rel => rel_value(page)), :class => ('active' if page == current_page)    
  end

  def gap
    #tag :li, link(super, '#'), :class => 'disabled'
  end

  def previous_or_next_page(page, text, classname)
    tag :a, link(text, page || '#'), :class => [classname[0..3], classname, ('disabled' unless page)].join(' ')
  end
end

def page_navigation_links(pages)
  will_paginate(pages, :class => 'pagination', :renderer => BootstrapLinkRenderer)
end