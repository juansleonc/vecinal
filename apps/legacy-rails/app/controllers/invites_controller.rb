class InvitesController < ApplicationController
  before_action :get_members_roles
  before_action :get_administrative_roles
  skip_before_action :authenticate_user!, only: :accept_by_user

  load_and_authorize_resource
  skip_load_resource only: [:create, :search]
  skip_authorize_resource only: :accept_by_user, unless: :user_signed_in?

  def create
    bulk_creator = InvitesBulkCreator.new(params, invite_params)
    @invite = bulk_creator.create
  end

  def destroy
    @invite.destroy
  end

  def resend
    @invite.send_email
    @invite.touch
  end

  def search_sent
    @invites_sent = set_pagination Invite.all_by_inviter(current_user).search_by(params[:query]), Company::INVITES_PER_PAGE
    load_more_at_bottom_respond_to @invites_sent, html: 'search_sent_results', partial: 'invite_sent'
  end

  def accept_by_user
    if user_signed_in?
      flash[:notice] = t 'invites.now_member', community: current_user.accountable.name if @invite.accept_by_user(current_user)
      redirect_to user_dashboard
    else
      redirect_to new_session_path(:user, invite: @invite.id)
    end
  end

private

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

  def invite_params
    params
      .require(:invite)
      .permit(permitted_invite_attributes)
      .merge inviter_id: current_user.id
  end

  def permitted_invite_attributes
    %i(accountable_type accountable_id first_name last_name email apartment_number role)
  end

  
end
