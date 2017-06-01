class User < ActiveRecord::Base
  has_many :locations_users
  has_many :locations, through: :locations_users
  acts_as_paranoid

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # required by the 'clerk'-gem (track creator and modifier user):
  include SentientUser

  # TODO: Check why 'attr_accessible' is deprecated
  #attr_accessible :username, :email, :password, :password_confirmation, :remember_me

  attr_accessor :login, :location_to_be_shared

  validates :username, :uniqueness => { :case_sensitive => false }, length: { in: 2..20 }
  validate :username_not_changed_on_update

  cattr_accessor :email_is_required
  @@email_is_required = false # will only be required upon update

  def email_required?
    @@email_is_required
  end

  # username OR email as login:
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      conditions.permit! if conditions.class.to_s == "ActionController::Parameters"
      where(conditions).first
    end
  end

  # do not require the current password even when setting a new one:
  def update_with_password(params={})
    if params[:password].blank?
      params.delete(:password)
      params.delete(:password_confirmation) if params[:password_confirmation].blank?
    end
    update_attributes(params)
  end

  def to_s
    return self.email unless self.email.nil?
    self.username
  end

  protected
  def username_not_changed_on_update
    if username_changed? && self.persisted?
      errors.add(:username, "may not be changed")
    end
  end
end
