class InvitesBulkCreator
  attr_reader :params, :invite_params

  def initialize(params, invite_params)
    @params = params
    @invite_params = invite_params
  end

  def create
    if params[:import_type] == 'single-invitation'
      create_single_invite
    elsif params[:import_type] == 'bulk-import'
      create_multiple_invites
    end
  end

  def create_single_invite    
    Invite.create invite_params
  end

  def create_multiple_invites
    valid_invites, invite = [], Invite.new(invite_params)

    if validate_common_attrs(invite)
      params[:bulk_import].split("\n").each do |invite_row|

        attrs = invite_row.split("\t").map { |p| p.strip }
        invite = Invite.create invite_params.merge(first_name: attrs[0], last_name: attrs[1], email: attrs[2], apartment_number: attrs[3])

        if invite.persisted?
          valid_invites << invite
        end
      end
    end
    valid_invites.empty? ? invite : valid_invites.first
  end

  def validate_common_attrs(invite)
    invite.valid?

    if invite.role.blank? || (invite.role == 'resident' && invite.accountable_id.blank?)
      invite.errors.messages.delete :inviter_id
      return false
    end
    return true
  end

end