class DeviseMailer < Devise::Mailer
    include Devise::Mailers::Helpers

    def confirmation_instructions(record, token, opts={}, admin = false)
        @token = token
        @record = record
        if record.create_by_admin > 0
            @admin = User.find record.create_by_admin
            if record.accountable.managed_by.blank?
                @content = t 'mailer.new_invite.content', name: @admin.full_name, community: record.accountable.name
                opts[:subject] = t 'mailer.new_invite.subject', name: @admin.full_name, community: record.accountable.name
            else
                @content = t 'mailer.new_invite.content', name: record.accountable.managed_by, community: record.accountable.name
                opts[:subject] = t 'mailer.new_invite.subject', name: record.accountable.managed_by, community: record.accountable.name
            end
            @content_extra = t 'mailer.new_invite.content_extra'
            @content_extra2 = t 'mailer.new_invite.content_extra2'
            
            devise_mail(record, :confirmation_instructions_create_by_admin, opts)
        else
            devise_mail(record, :confirmation_instructions, opts)
        end
    end

    def password_change(record, opts={})
        if record.change_password
            opts[:subject] = t 'devise.welcome'
            devise_mail(record, :first_password_change, opts)
        else
            devise_mail(record, :password_change, opts)
        end
    end

end