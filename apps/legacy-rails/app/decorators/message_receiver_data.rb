class MessageReceiverData

  def initialize(message, user)
    @message = message
    @user = user
    @message.sender == @user ? self.extend(Sender) : self.extend(Receiver)
  end

  def sender
    @sender ||= @message.sender
  end

  def receivers
    @receivers ||= @message.users - [@message.sender]
  end

  module Sender
    def logo
      @logo ||= receivers.first.logo.url(:standard)
    end

    def letter
      @letter ||= receivers.first.first_name_letter
    end

    def parties
      return @parties if @parties
      first = receivers.first
      @parties = if @message.users.count == 2
        "<span class='with-profile-banner' data-user-id='#{first.id}'>#{first.full_name}</span>"
      else
        buildings = []
        receivers.each do |receiver|
          if receiver.accountable_type == 'Building'
            buildings << receiver.accountable.name unless buildings.include? receiver.accountable.name
          end
        end
        if buildings.count > 1
          "#{receivers.first(3).map(&:first_name).join(', ').capitalize}..."
        else
          "<span class='with-profile-banner' >#{buildings.first}</span>"
        end
      end
    end

    def full_parties
      @full_parties ||= "Me to #{parties}"
    end
  end

  module Receiver
    def logo
      @logo ||= sender.logo.url(:standard)
    end

    def letter
      @letter ||= sender.first_name_letter
    end

    def parties
      @parties ||= "<span class='with-profile-banner' data-user-id='#{sender.id}'>#{sender.full_name}</span>"
    end

    def full_parties
      @full_parties ||= "<span class='with-profile-banner' data-user-id='#{sender.id}'>#{sender.full_name}</span> to me"
    end
  end

end
