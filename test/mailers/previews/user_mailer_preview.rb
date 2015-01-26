# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/account_activation
  def account_activation
    UserMailer.account_activation
  end

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/password-reset
  def password-reset
    UserMailer.password-reset
  end

end
