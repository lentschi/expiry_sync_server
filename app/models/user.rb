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
  
  attr_accessor :login
  
  validates :username, :uniqueness => { :case_sensitive => false }, length: { in: 2..20 }
    
  cattr_accessor :email_is_required
  @@email_is_required = false # will only be required upon update
    
  def email_required?
    @@email_is_required
  end
  
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end
end
