class UserNotificationsManager

  def initialize(user)
    @user = user
  end

  def messages_unread
    @messages_unread ||= Message.with_user(@user).unread_by(@user)
    # @messages_unread ||= Message.with_user(@user).unread_by(@user)
  end

  def messages_inbox
    @messages_inbox ||= messages_unread.inbox_for(@user).count
  end

  def messages_done
    @messages_done ||= messages_unread.marked(@user, 'done').count
  end

  def messages_deleted
    @messages_deleted ||= messages_unread.marked(@user, 'deleted').count
  end

  def messages_total
    messages_inbox + messages_done + messages_deleted
  end

  def invites_received
    @invites_received ||= @user.admin? ? @user.accountable.requests.count : 0
  end

  def service_requests_open
    @service_requests_open ||= ServiceRequest.with_user(@user).open.unread_by(@user).count
  end

  def service_requests_closed
    @service_requests_closed ||= ServiceRequest.with_user(@user).closed.unread_by(@user).count
  end

  def events_upcoming
    @events_upcoming ||= @user.events.upcoming.unread_by(@user).count
  end

  def events_past
    @events_past ||= @user.events.past.unread_by(@user).count
  end

  def reservations
    @reservations ||= if @user.admin?
      Reservation.joins(:amenity).where(amenities: { building_id: @user.buildings }).unread_by(@user).count
    else
      @user.reservations.unread_by(@user).count
    end
  end

  def polls
    @polls ||= Poll.where(id: @user.shared_with_my_community_ids(Poll)).unread_by(@user).count
  end

  def general_notifications
    service_requests_open + service_requests_closed + events_upcoming + events_past + reservations + polls
  end

  def total_notifications
    messages_total + general_notifications
  end

end