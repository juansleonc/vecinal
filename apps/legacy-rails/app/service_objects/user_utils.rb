module UserUtils

  module Admin
    def i_am?
      'an admin'
    end

    def contacts(company = 0,building = 0)
     
      if company.to_i > 0
        
        User.where.not(id: id).where('accountable_type = ? AND accountable_id = ?',
        'Company', company.to_i, 
        ).where(accepted: true)
      elsif building.to_i > 0
        User.where.not(id: id).where('accountable_type = ? AND accountable_id = ?',
          'Building', building.to_i).where(accepted: true)
      else
        User.where.not(id: id).where('
          (accountable_type = ? AND accountable_id = ?) 
          OR (accountable_type = ? AND accountable_id IN (?))',
          'Company', accountable_id, 
          'Building', accountable.buildings.ids).where(accepted: true)
      end
    end

    def contacts_off
      User.where.not(id: id).where('
        (accountable_type = ? AND accountable_id = ?) 
        OR (accountable_type = ? AND accountable_id IN (?))',
        'Company', accountable_id, 
        'Building', accountable.buildings.ids).where(confirmed_at: nil)
    end

    def company_contacts
      User.where(accepted: true).where(['accountable_type = ? AND accountable_id = ?', 'Company', accountable_id])
    end

    def buildings
      accountable.buildings
    end

    def my_company
      accountable
    end

    def create_root_folders
      accountable.buildings.each do |building|
        Folder.create folderable: building, name: building.name
      end
      Folder.create folderable: accountable, name: accountable.name
      Folder.roots_by_user self
    end

    def payments_enabled?
      buildings.payments_enabled.present?
    end

    def payments_associated
      Payment.by_building buildings
    end

    def communities
      [accountable] + accountable.buildings
    end

    def communities_search_by(query)
      Company.where(id: accountable_id).search_by(query) + accountable.buildings.search_by(query)
    end

    def shared_with_my_community_ids(model_class)
      model_with_shares = model_class.joins(:shares)
      model_with_shares.where(shares: {recipientable: accountable}).ids + model_with_shares.where(shares: {recipientable: buildings}).ids
    end

  end

  module Collaborator
    def i_am?
      'an collaborator'
    end
    def contacts(company = 0,building = 0)
     
      if company.to_i > 0
        
        User.where.not(id: id).where('accountable_type = ? AND accountable_id = ?',
        'Company', company.to_i, 
        ).where(accepted: true)
      elsif building.to_i > 0
        User.where.not(id: id).where('accountable_type = ? AND accountable_id = ?',
          'Building', building.to_i).where(accepted: true)
      else
        User.where.not(id: id).where('
          (accountable_type = ? AND accountable_id = ?) 
          OR (accountable_type = ? AND accountable_id IN (?))',
          'Company', accountable_id, 
          'Building', accountable.buildings.ids).where(accepted: true)
      end
    end

    def company_contacts
      User.where(accepted: true).where(['accountable_type = ? AND accountable_id = ?', 'Company', accountable_id])
    end

    def buildings
      accountable.buildings
    end

    def my_company
      accountable
    end


    def create_root_folders
      accountable.buildings.each do |building|
        Folder.create folderable: building, name: building.name
      end
      Folder.create folderable: accountable, name: accountable.name
      Folder.roots_by_user self
    end

    def payments_enabled?
      buildings.payments_enabled.present?
    end

    def payments_associated
      Payment.by_building buildings
    end

    def communities
      [accountable] + accountable.buildings
    end

    def communities_search_by(query)
      Company.where(id: accountable_id).search_by(query) + accountable.buildings.search_by(query)
    end

    def shared_with_my_community_ids(model_class)
      model_with_shares = model_class.joins(:shares)
      model_with_shares.where(shares: {recipientable: accountable}).ids + model_with_shares.where(shares: {recipientable: buildings}).ids
    end

  end

  module Resident
    def i_am?
      'a resident'
    end

    
    def contacts(company = 0,building = 0)
     
      if company.to_i > 0
        
        User.where.not(id: id).where('accountable_type = ? AND accountable_id = ?',
        'Company', company.to_i, 
        ).where(accepted: true)
      elsif building.to_i > 0
        User.where.not(id: id).where('accountable_type = ? AND accountable_id = ?',
          'Building', building.to_i).where(accepted: true)
      else
        User.where.not(id: id).where('
          (accountable_type = ? AND accountable_id = ?) 
          OR (accountable_type = ? AND accountable_id IN (?))',
          'Company', accountable.company_id, 
          'Building', accountable_id).where(accepted: true)
      end
    end

    def company_contacts
      User.where(accepted: true).where('accountable_type = ? AND accountable_id = ?', 'Company', accountable.company_id)
    end

    def buildings
      Building.where id: accountable_id
    end

    def my_company
      accountable.company
    end

    def create_root_folders
      Folder.create folderable: accountable, name: accountable.name
      Folder.roots_by_user self
    end

    def payments_enabled?
      accountable.payments_enabled?
    end

    def payments_associated
      payments
    end

    def communities
      [accountable]
    end

    def communities_search_by(query)
      Building.where(id: accountable_id).search_by(query)
    end

    def shared_with_my_community_ids(model_class)
      model_class.joins(:shares).where(shares: {recipientable: accountable}).ids
    end
  end

  module BoardMember
    def i_am?
      'a board member'
    end
  
    def board_member
      Building.where id: accountable_id
    end

    
    def contacts(company = 0,building = 0)
     
      if company.to_i > 0
        
        User.where.not(id: id).where('accountable_type = ? AND accountable_id = ?',
        'Company', company.to_i, 
        ).where(accepted: true)
      elsif building.to_i > 0
        User.where.not(id: id).where('accountable_type = ? AND accountable_id = ?',
          'Building', building.to_i).where(accepted: true)
      else
        User.where.not(id: id).where('
          (accountable_type = ? AND accountable_id = ?) 
          OR (accountable_type = ? AND accountable_id IN (?))',
          'Company', accountable.company_id, 
          'Building', accountable_id).where(accepted: true)
      end
    end

    def company_contacts
      User.where(accepted: true).where('accountable_type = ? AND accountable_id = ?', "Building", accountable.id)
    end

    def buildings
      Building.where id: accountable_id
    end

    def my_company
      accountable.company
    end

    def create_root_folders
      Folder.create folderable: accountable, name: accountable.name
      Folder.roots_by_user self
    end

    def payments_enabled?
      accountable.payments_enabled?
    end

    def payments_associated
      payments
    end

    def communities
      [accountable]
    end

    def communities_search_by(query)
      Building.where(id: accountable_id).search_by(query)
    end

    def shared_with_my_community_ids(model_class)
      model_class.joins(:shares).where(shares: {recipientable: accountable}).ids
    end
  end

  module Tenant
    def i_am?
      'a tenant'
    end
  
    def tenant
      Building.where id: accountable_id
    end

    def contacts(company = 0,building = 0)
     
      if company.to_i > 0
        
        User.where.not(id: id).where('accountable_type = ? AND accountable_id = ?',
        'Company', company.to_i, 
        ).where(accepted: true)
      elsif building.to_i > 0
        User.where.not(id: id).where('accountable_type = ? AND accountable_id = ?',
          'Building', building.to_i).where(accepted: true)
      else
        User.where.not(id: id).where('
          (accountable_type = ? AND accountable_id = ?) 
          OR (accountable_type = ? AND accountable_id IN (?))',
          'Company', accountable.company_id, 
          'Building', accountable_id).where(accepted: true)
      end
    end

    def company_contacts
      User.where(accepted: true).where('accountable_type = ? AND accountable_id = ?', 'Company', accountable.company_id)
    end

    def buildings
      Building.where id: accountable_id
    end

    def my_company
      accountable.company
    end

    def create_root_folders
      Folder.create folderable: accountable, name: accountable.name
      Folder.roots_by_user self
    end

    def payments_enabled?
      accountable.payments_enabled?
    end

    def payments_associated
      payments
    end

    def communities
      [accountable]
    end

    def communities_search_by(query)
      Building.where(id: accountable_id).search_by(query)
    end

    def shared_with_my_community_ids(model_class)
      model_class.joins(:shares).where(shares: {recipientable: accountable}).ids
    end
  end
  module Agent
    def i_am?
      'a agent'
    end
  
    def Agent
      Building.where id: accountable_id
    end

    def contacts(company = 0,building = 0)
     
      if company.to_i > 0
        
        User.where.not(id: id).where('accountable_type = ? AND accountable_id = ?',
        'Company', company.to_i, 
        ).where(accepted: true)
      elsif building.to_i > 0
        User.where.not(id: id).where('accountable_type = ? AND accountable_id = ?',
          'Building', building.to_i).where(accepted: true)
      else
        User.where.not(id: id).where('
          (accountable_type = ? AND accountable_id = ?) 
          OR (accountable_type = ? AND accountable_id IN (?))',
          'Company', accountable.company_id, 
          'Building', accountable_id).where(accepted: true)
      end
    end

    def company_contacts
      User.where(accepted: true).where('accountable_type = ? AND accountable_id = ?', 'Company', accountable.company_id)
    end

    def buildings
      Building.where id: accountable_id
    end

    def my_company
      accountable.company
    end

    def create_root_folders
      Folder.create folderable: accountable, name: accountable.name
      Folder.roots_by_user self
    end

    def payments_enabled?
      accountable.payments_enabled?
    end

    def payments_associated
      payments
    end

    def communities
      [accountable]
    end

    def communities_search_by(query)
      Building.where(id: accountable_id).search_by(query)
    end

    def shared_with_my_community_ids(model_class)
      model_class.joins(:shares).where(shares: {recipientable: accountable}).ids
    end
  end
  module Supplier
    def i_am?
      'a supplier'
    end
  end

  module NoRole
    def i_am?
      'a no role'
    end

    def contacts(company = 0,building = 0)
      User.none
    end

    def buildings
      Building.none
    end

    def payments_associated
      payments
    end

    def my_company
      nil
    end

    def shared_with_my_community_ids(model_class)
      []
    end
  end

end