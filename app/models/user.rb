class User < ActiveRecord::Base
  has_and_belongs_to_many :locations
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  # required by the 'clerk'-gem (track creator and modifier user):
  include SentientUser
  
  # TODO: Check why 'attr_accessible' is deprecated
  #attr_accessible :username, :email, :password, :password_confirmation, :remember_me
  
  validates :username, length: { in: 2..20 }
    
  def email_required?
    false
  end
end
