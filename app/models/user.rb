class User < ActiveRecord::Base
  has_many :locations_users
  has_many :locations, through: :locations_users
  acts_as_paranoid
  after_initialize :fix_broken_sqlite_blob

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # required by the 'clerk'-gem (track creator and modifier user):
  include SentientUser

  # TODO: Check why 'attr_accessible' is deprecated
  #attr_accessible :username, :email, :password, :password_confirmation, :remember_me

  attr_accessor :login, :location_to_be_shared

  validates :username, length: { in: 2..20 }
  validate :username_uniqueness
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
      where(conditions).where([username_query + " OR lower(email) = :value", { :value => login.downcase }]).first
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
    params.delete(:current_password)
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

  def username_uniqueness
    return if self.username.nil?
    entries = User.where(User.username_query, { :value => self.username.downcase })
    if entries.count >= 2 || entries.count == 1 && (new_record? || entries.first.id != self.id )
      errors[:username] << I18n.t('username_taken')
    end
  end

  def fix_broken_sqlite_blob
    if ActiveRecord::Base.connection.class.to_s == "ActiveRecord::ConnectionAdapters::SQLite3Adapter"
      # Couldn't find out why this is happening for sqlite blobs
      # maybe this is fixed with a newer ActiveRecord version -> meanwhile workaround:
      self.username = '' if self.username == "x''"
    end
  end

  def self.username_query
    if ActiveRecord::Base.connection_config[:adapter] != 'mysql2'
      return 'LOWER(username) = :value'
    end

    # Had to convert username from VARCHAR to VARBINARY
    # as otherwise 'myuser ' = 'myuser' is true on mysql.
    # There were already users with trailing whitespaces in the original
    # Postgres DB, so the easy way of simply using validation to prevent this cannot be taken.
    # However the LOWER() function doesn't work for mysql's VARBINARY -> cast it first:
    'LOWER(CONVERT(username USING utf8)) = :value'
  end
end
