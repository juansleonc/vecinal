# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  def new_message
    message = Message.last
    UserMailer.new_message message, message.users.last
  end

  def new_message_urgent
    message = Message.where(urgent: true).last
    UserMailer.new_message message, message.users.last
  end

  def new_event
    event = Event.last
    UserMailer.new_event event, event.users.last
  end

  def new_invite
    UserMailer.new_invite(Invite.last)
  end

  def new_invite_existing
    invite = Invite.last
    invite.email = User.where(accepted: true).last.email
    UserMailer.new_invite(invite)
  end

  def new_join_request
    requester = User.where(accountable_type: 'Building').last
    UserMailer.new_join_request requester, requester.accountable.admins.last
  end

  def request_processed_accepted
    user = User.where(accepted: true).last
    UserMailer.request_processed user
  end

  def request_processed_declined
    user = User.where.not(accountable_id: nil, accountable_type: nil).last
    UserMailer.request_processed user
  end

  def new_wall_comment_user
    comment = Comment.where(commentable_type: 'User').where('user_id != commentable_id').last
    UserMailer.new_wall_comment_user comment
  end


  def new_wall_comment_company
    comment = Comment.where(commentable_type: 'Company').last
    UserMailer.new_wall_comment_company comment
  end


  def new_wall_comment_building
    comment = Comment.where(commentable_type: 'Building').last
    UserMailer.new_wall_comment_building comment
  end

  def new_classified
    classified = Classified.joins(:shares).where.not(shares: { recipientable_id: nil }).last
    UserMailer.new_classified classified, classified.recipient.contacts.last
  end

  def new_poll
    poll = Poll.joins(:shares).where.not(shares: { recipientable_id: nil }).last
    UserMailer.new_poll poll, poll.recipient.contacts.last
  end

  def new_comment_reply
    # comment = Comment.where(commentable_type: 'Comment').joins(
    #   "INNER JOIN comments AS father ON father.id = comments.commentable_id AND father.commentable_type = 'User'"
    # ).last
    comment = Comment.last
    UserMailer.new_comment_reply comment, comment.commentable.publisher.email
  end

  def new_service_request
    service_request = ServiceRequest.where(responsible_type: 'User').last
    UserMailer.new_service_request service_request, service_request.responsible
  end

  def new_service_request_urgent
    service_request = ServiceRequest.where(responsible_type: 'User', urgent: true).last
    UserMailer.new_service_request service_request, service_request.responsible
  end

  def new_reservation
    reservation = Reservation.last
    UserMailer.new_reservation reservation, reservation.amenity.building.company.contacts.last
  end

  def report_software_problem
    cf = ContactForm.new(subject: 'Test for software problem email', message: 'This is a message for report software problem')
    UserMailer.report_software_problem cf, User.where(accepted: true, role: 'resident').first
  end

  def condo_media_update
    UserMailer.condo_media_update 'A new building called Fake Building has been created'
  end

  def report_payment_account_updated
    UserMailer.report_payment_account_updated PaymentAccount.last, User.last
  end

  def new_review_company
    review = Review.where(reviewable_type: 'Company').last
    UserMailer.new_review_company review
  end

  def new_review_building
    review = Review.where(reviewable_type: 'Building').last
    UserMailer.new_review_building review
  end

  # def new_review_reply
  #   comment = Comment.where(commentable_type: 'Review').last
  #   UserMailer.new_review_reply comment
  # end

end
