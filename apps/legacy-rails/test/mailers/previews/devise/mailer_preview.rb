class Devise::MailerPreview < ActionMailer::Preview
  # hit http://localhost:3000/rails/mailers/devise/mailer/confirmation_instructions
  def confirmation_instructions
    Devise::Mailer.confirmation_instructions(User.first, 'faketoken', {})
  end

  # hit http://localhost:3000/rails/mailers/devise/mailer/reset_password_instructions
  def reset_password_instructions
    Devise::Mailer.reset_password_instructions(User.first, 'faketoken', {})
  end

  # hit http://localhost:3000/rails/mailers/devise/mailer/password_change
  def password_change
    Devise::Mailer.password_change(User.first)
  end

end
