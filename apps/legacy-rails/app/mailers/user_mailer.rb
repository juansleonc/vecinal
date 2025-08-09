class UserMailer < ApplicationMailer
  include ActionView::Helpers::UrlHelper::ClassMethods
  require 'open-uri'
  def new_message(message, receiver)
    @user = message.sender
    @header = t 'mailer.new_message.header', message: link_to(Message.model_name.human, messages_url)
    @content = render(partial: 'user_mailer_partials/message_content', locals: { message: message, receiver: receiver })
    @email_to = receiver.email
    urgent = message.urgent ? "(#{t 'messages.urgent'}) " : ''
    subject = urgent + message.title
    attachment = []
    message.attachments.each_with_index do |attachment, i| 
      if Rails.env.production?
        read_file_s3 = attachment.file_attachment.url(:original)
      else
        read_file_s3 = root_url().chomp('/') + attachment.file_attachment.url(:original)
      end
      attachments[attachment.file_attachment_file_name] = open("#{read_file_s3}").read
    end
    @comment_url = messages_url

    classNameBase64 = Base64.strict_encode64(message.class.name).encode("UTF-8")
    reply_to = "#{message.id.to_s}.#{classNameBase64}@parse.condo-media.com"

    mail to: @email_to, subject: subject, template_name: 'notification', reply_to: reply_to
  end

  def new_event(event, receiver)
    @user = event.sender
    @header = t 'mailer.new_event.header', event: link_to(Event.model_name.human, events_url)
    @content = render(partial: 'user_mailer_partials/event_content', locals: { event: event })
    @email_to = receiver.email
    attachment = []
    event.attachments.each_with_index do |attachment, i| 
      if Rails.env.production?
        read_file_s3 = attachment.file_attachment.url(:original)
      else
        read_file_s3 = root_url().chomp('/') + attachment.file_attachment.url(:original)
      end
      attachments[attachment.file_attachment_file_name] = open("#{read_file_s3}").read
    end
    @comment_url = events_url
    classNameBase64 = Base64.strict_encode64(event.class.name).encode("UTF-8")
    reply_to = "#{event.id.to_s}.#{classNameBase64}@parse.condo-media.com"
    mail to: @email_to, subject: t('mailer.new_event.subject', name: @user.full_name), template_name: 'notification', reply_to: reply_to
  end

  def new_invite(invite)
    @invite = invite
    @user = invite.inviter
    @header = t 'mailer.new_invite.header'
    @content = t 'mailer.new_invite.content', name: @user.full_name, community: invite.accountable.name
    @email_to = invite.email
    
    mail to: @email_to, subject: t('mailer.new_invite.subject', name: @user.full_name, community: invite.accountable.name)
  end

  def new_join_request(requester, admin)
    community_name = requester.accountable.name
    @user = requester
    @header = t 'mailer.new_join_request.header', request: link_to(t('mailer.new_join_request.request'),
      company_invites_received_url(admin.accountable))
    @content = t 'mailer.new_join_request.content', name: requester.full_name, community: community_name
    @email_to = admin.email
    @comment_url = root_url
    mail to: admin.email, subject: t('mailer.new_join_request.subject', name: requester.full_name, community: community_name),
      template_name: 'notification'
  end

  def request_processed(user)
    outcome = user.accepted ? t('mailer.request_processed.approved') : t('mailer.request_processed.declined')
    @header = t 'mailer.request_processed.header', outcome: outcome
    @content = t 'mailer.request_processed.content', community: user.accountable.name, outcome: outcome
    @email_to = user.email
    @comment_url = root_url
    mail to: user.email, subject: t('mailer.request_processed.subject', outcome: outcome, community: user.accountable.name),
      template_name: 'notification'
  end

  def new_wall_comment_user(comment)
    build_new_wall_comment comment, news_feed_url
  end

  def new_wall_comment_company(comment)
    build_new_wall_comment comment, company_root_url(comment.commentable, subdomain: 'www')
  end

  def new_wall_comment_building(comment)
    build_new_wall_comment comment, building_root_url(subdomain: comment.commentable.subdomain)
  end

  def new_classified(classified, receiver)
    @user = classified.publisher
    @header = t 'mailer.new_classified.header', offer: link_to(t('mailer.new_classified.offer'), classifieds_url)

    #@content = classified.title
    @content = render(partial: 'user_mailer_partials/classified', locals: { classified: classified })
    @email_to = receiver.email
    attachment = []
    classified.attachments.each_with_index do |attachment, i| 
      if Rails.env.production?
        read_file_s3 = attachment.file_attachment.url(:original)
      else
        read_file_s3 = root_url().chomp('/') + attachment.file_attachment.url(:original)
      end
      attachments[attachment.file_attachment_file_name] = open("#{read_file_s3}").read
    end   
    @comment_url = classifieds_url

    classNameBase64 = Base64.strict_encode64(classified.class.name).encode("UTF-8")
    reply_to = "#{classified.id.to_s}.#{classNameBase64}@parse.condo-media.com"
    
    mail to: receiver.email, subject: t('mailer.new_classified.subject', name: @user.full_name, building: @user.accountable.name), template_name: 'notification', reply_to: reply_to
  end

  def new_poll(poll, user)
    @user = poll.publisher
    @header = t 'mailer.new_poll.header', poll: link_to(Poll.model_name.human, polls_url)
    @content = poll.question
    @email_to = user.email
    attachment = []
    poll.attachments.each_with_index do |attachment, i| 
      if Rails.env.production?
        read_file_s3 = attachment.file_attachment.url(:original)
      else
        read_file_s3 = root_url().chomp('/') + attachment.file_attachment.url(:original)
      end
      attachments[attachment.file_attachment_file_name] = open("#{read_file_s3}").read
    end  
    @comment_url = polls_url
    mail to: @email_to, subject: t('mailer.new_poll.subject', name: @user.full_name), template_name: 'notification'
  end

  def new_comment_reply(comment, email)
    @user = comment.user
    @header = t 'mailer.new_comment_reply.header', commentable: comment.commentable.class.model_name.human
    subject = ''
    
    if comment.commentable.class.name == "Reservation"
      amenity_name = comment.commentable.amenity.name
      building_name = comment.commentable.amenity.building.name
      subject = t 'mailer.new_reservation_repĺay.subject', {amenity: amenity_name, building:  building_name}
    elsif comment.commentable.class.name == "Comment"
      subject = t 'mailer.new_news_repĺay.subject', {building: comment.commentable.user.accountable.name} 
    elsif comment.commentable.class.name == "ServiceRequest"
      urgent = comment.commentable.urgent ? "(#{t 'service_requests.urgent'}) " : ''
      subject = urgent + t('general.number_request') + comment.commentable.id.to_s + ' - ' +  comment.commentable.title
    else
      subject = comment.commentable.title
    end

    @content = render(partial: 'user_mailer_partials/comment_reply', locals: { comment: comment, subject: subject })
    
    if comment.commentable.class.name == "Reservation"
      @content = render(partial: 'user_mailer_partials/reservation_content', locals: { reservation: comment.commentable, content: comment.content })
    end
    attachment = []
    comment.attachments.each_with_index do |attachment, i| 
      read_file_s3 = attachment.file_attachment.url(:original)
      attachments[attachment.file_attachment_file_name] = open("#{read_file_s3}").read
    end
    @email_to = email
    #reply_to = comment.id.to_s + '@parse.condo-media.com'
    #classNameBase64 = Base64.encode64(comment.commentable.class.name)
    classNameBase64 = Base64.strict_encode64(comment.commentable.class.name).encode("UTF-8")
    reply_to = "#{comment.id.to_s}.#{classNameBase64}@parse.condo-media.com"

    case comment.commentable.class.name
    when 'ServiceRequest'
      @comment_url = service_requests_url 
    when 'Comment' #Profile
      @comment_url = news_feed_url
    when 'Message'
      @comment_url = messages_url
    when 'Event'
      @comment_url = events_url
    when 'Reservation'
      @comment_url = reservations_url
    when 'Classified'
      @comment_url = classifieds_url
    else
      @comment_url = root_url
    end
    
    
    mail to: @email_to, subject: t('mailer.new_comment_reply.subject', name: @user.full_name), template_name: 'notification', reply_to: reply_to
  end

  def new_service_request(service_request, receiver)
    @user = service_request.user
    @header = t 'mailer.new_service_request.header', request: link_to(ServiceRequest.model_name.human, service_requests_url)
    @content = render(partial: 'user_mailer_partials/service_content', locals: { service_request: service_request })
    
    @email_to = receiver.email
    urgent = service_request.urgent ? "(#{t 'service_requests.urgent'}) " : ''
    subject = urgent + t('general.number_request') + service_request.id.to_s + ' - ' +  service_request.title
    attachment = []
    service_request.attachments.each_with_index do |attachment, i| 
      if Rails.env.production?
        read_file_s3 = attachment.file_attachment.url(:original)
      else
        read_file_s3 = root_url().chomp('/') + attachment.file_attachment.url(:original)
      end
      attachments[attachment.file_attachment_file_name] = open("#{read_file_s3}").read
    end  
    @comment_url = service_requests_url

    classNameBase64 = Base64.strict_encode64(service_request.class.name).encode("UTF-8")
    reply_to = "#{service_request.id.to_s}.#{classNameBase64}@parse.condo-media.com"

    
    mail to: @email_to, subject: subject, template_name: 'notification', reply_to: reply_to
  end


  def change_responsible_service_request(service_request, responsible)
    @user = service_request.user
    @header = t 'mailer.new_service_request.header', request: link_to(ServiceRequest.model_name.human, service_requests_url)
    @content = render(partial: 'user_mailer_partials/service_content', locals: { service_request: service_request })
    @email_to = responsible.email
    urgent = service_request.urgent ? "(#{t 'service_requests.urgent'}) " : ''
    subject = urgent + t('general.number_request') + service_request.id.to_s + ' - ' +  service_request.title
    attachment = []
    service_request.attachments.each_with_index do |attachment, i| 
      if Rails.env.production?
        read_file_s3 = attachment.file_attachment.url(:original)
      else
        read_file_s3 = root_url().chomp('/') + attachment.file_attachment.url(:original)
      end
      attachments[attachment.file_attachment_file_name] = open("#{read_file_s3}").read
    end  
    @comment_url = service_requests_url
    mail to: @email_to, subject: subject, template_name: 'notification'
  end

  def change_responsible_reservation(reservation, responsible)
    @user = reservation.reserver
    @header = t 'mailer.new_reservation.header', reservation: link_to(t('mailer.new_reservation.request'), reservations_url)
    #@content = reservation.message
    @content = render(partial: 'user_mailer_partials/reservation_content', locals: { reservation: reservation, content: '' })
    @email_to = responsible.email
    @comment_url = reservations_url
    mail to: @email_to, subject: t('mailer.new_reservation.subject', name: @user.full_name), template_name: 'notification'
  end

  

  def new_reservation(reservation, receiver)
    @user = reservation.reserver
    @header = t 'mailer.new_reservation.header', reservation: link_to(t('mailer.new_reservation.request'), reservations_url)
    #@content = reservation.message
    @content = render(partial: 'user_mailer_partials/reservation_content', locals: { reservation: reservation, content: '' })
    @email_to = receiver.email
    @comment_url = reservations_url

    classNameBase64 = Base64.strict_encode64(reservation.class.name).encode("UTF-8")
    reply_to = "#{reservation.id.to_s}.#{classNameBase64}@parse.condo-media.com"
    
    mail to: @email_to, subject: t('mailer.new_reservation.subject', name: @user.full_name), template_name: 'notification', reply_to: reply_to
  end

  def report_software_problem(email_data, sender)
    @user = sender
    @header = t 'mailer.report_software_problem.header'
    details = @user.contact_details
    unit = details.apartment_numbers.present? ? ", #{ContactDetails.human_attribute_name :apartment_numbers} #{details.apartment_numbers_joined}" : ''
    @content = "#{email_data.message}<br/><br/>Email: #{@user.email}<br/>Community: #{@user.accountable.name}#{unit}
      <br/>Phone: #{details.phone}<br/>Mobile Phone: #{details.mobile_phone}<br/>Role: #{@user.role}"
    @email_to = CM_INFO_MAIL
    @comment_url = root_url
    mail to: CM_INFO_MAIL, subject: email_data.subject, template_name: 'notification'
  end

  def condo_media_update(message)
    @content = message
    @email_to = CM_INFO_MAIL
    mail to: CM_INFO_MAIL, subject: "Condo Media update"
  end

  def report_payment_account_updated(account, user)
    @user = user
    @header = t 'mailer.report_payment_account_updated.header', building: account.building.name
    @content = ''
    @email_to = CM_INFO_MAIL
    @comment_url = root_url
    mail to: CM_INFO_MAIL, subject: t('mailer.report_payment_account_updated.subject', building: account.building.name),
      template_name: 'notification'
  end

  def new_review_company(review)
    build_new_review review, company_public_reviews_url(review.reviewable, subdomain: 'www')
  end

  def new_review_building(review)
    build_new_review review, building_reviews_url(subdomain: review.reviewable.subdomain)
  end

  # def new_review_reply(comment)
  #   @user = comment.user
  #   @header = t 'mailer.new_review_reply.header'
  #   @content = comment.content
  #   @email_to = comment.commentable.reviewable.email
  #   mail to: @email_to, subject: t('mailer.new_review_reply.subject', name: @user.full_name), template_name: 'notification'
  # end

# This methods are not used. We kept these for future re-implementation for sale and purchase

  # def new_sale(deal_purchase, buyer)
  #   @deal = deal_purchase.deal
  #   @buyer = buyer
  #   mail( to: @deal.business.email, subject: t('mailer.new_sale.subject') )
  # end

  # def new_purchase(deal_purchase, buyer)
  #   @deal = deal_purchase.deal
  #   @buyer = buyer
  #   mail( to: buyer.email, subject: t('mailer.new_purchase.subject') )
  # end

private

  def link_to(name, url)
    view_context.link_to name, url, style: 'text-decoration: none', target: '_blank'
  end

  def build_new_wall_comment(comment, url)
    @user = comment.user
    @header = t 'mailer.new_wall_comment.header', timeline: link_to(t('mailer.new_wall_comment.timeline'), url)
    @content = comment.content
    @email_to = comment.commentable.email
    @comment_url = news_feed_url
    mail to: @email_to, subject: t('mailer.new_wall_comment.subject', name: @user.full_name), template_name: 'notification'
  end

  def build_new_review(review, url)
    @user = review.user
    @header = t 'mailer.new_review.header', review: link_to(Review.model_name.human, url)
    @content = review.comment
    @email_to = review.reviewable.email
    @comment_url = root_url
    mail to: @email_to, subject: t('mailer.new_review.subject', name: @user.full_name), template_name: 'notification'
  end

end
