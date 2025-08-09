module Select2able
  extend ActiveSupport::Concern

  included do
  end

  class_methods do
  end

  def receivers
    render json: communities_and_contacts_for_select2
  end

  private

  def communities_and_contacts_for_select2
    if params[:query].present?
      communities = current_user.communities_search_by(params[:query]).map { |c| actors_json_builder(c, :name) }
      contacts = current_user.contacts.search_by(params[:query]).map { |c| actors_json_builder(c, :full_name) }
      
      group_communities = communities.present? ? [text: 'Communities:'] + communities : []
      group_contacts = contacts.present? ? [text: 'Contacts:'] + contacts : []
      
      group_communities + group_contacts
    end
  end

  def actors_json_builder(c, attr_name)
    if c.class.name == 'User' || c.class.name == 'Admin'
      { id: "#{c.class.name},#{c.id}", text: c.try(attr_name), logo: asset_path(c.logo.url :square), letter: c.first_name_letter,apartment_numbers: c.contact_details.apartment_numbers.join(" - "), accountable: c.accountable.name   }  
    else
      { id: "#{c.class.name},#{c.id}", text: c.try(attr_name), logo: asset_path(c.logo.url :square), letter: c.first_name_letter,apartment_numbers: '', accountable: ''  }  
    end
  end
  
  def asset_path(path)
    ActionController::Base.helpers.asset_path path
  end

end