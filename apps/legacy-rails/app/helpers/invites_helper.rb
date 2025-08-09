module InvitesHelper

  def role_by_community(name)
    case name
      when 'Company' then t('roles.administrator')
      when 'Collaborator' then t('roles.collaborator')
      when 'Building' then t('roles.resident')
      when 'Business' then t('roles.supplier')
      when 'BoardMember' then t('roles.board_member')
      when 'Tenant' then t('roles.tenant')
      when 'Agent' then t('roles.agent')
    end
  end

end
