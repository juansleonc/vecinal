class AdminUser < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :registerable, :confirmable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable, :lockable

  def full_name
    email
  end

  def logo
    User.new.logo
  end

end
