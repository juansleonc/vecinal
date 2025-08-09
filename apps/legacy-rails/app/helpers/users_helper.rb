module UsersHelper

  # def search_news_feed_link
  #   if current_user.admin?
  #     company_search_news_feed_path current_user.accountable
  #   elsif current_user.resident?
  #     resident_search_news_feed_path
  #   end
  # end

  def map_user_invite(user, invite_id)
    if invite = Invite.find_by_id(invite_id)
      user.first_name = invite.first_name
      user.last_name = invite.last_name
      user.email = invite.email
    end
  end

  def subdomain_for_user
    @subdomain_for_user ||= current_user.resident? ? current_user.accountable.subdomain : 'www'
  end

  def user_about_row(f, field, value)
    can_manage = can?(:manage, @user)
    input = if can_manage
      "<td class=\"to-edit hidden\">
        #{block_given? ? yield : f.text_field(field)}
      </td>"
    end
    "<tr>
      <td>#{f.label field}</td>
      <td>#{value} #{link_to t('general.edit'), '#', class: 'pull-right edit' if can_manage}</td>
      #{input}
    </tr>".html_safe
  end

  def with_profile_banner_link(user)
    link_to user_profile_path(user), class: 'with-profile-banner', data: { user_id: user.id } do
      block_given? ? yield : user.full_name.split.map(&:capitalize).join(' ')
    end
  end

  def link_to_my_community(user)
    if user.admin? || user.collaborator?
      company_url(@user.accountable, subdomain: 'www')
    elsif user.resident?
      building_root_url(subdomain: user.accountable.subdomain)
    end
  end

end
