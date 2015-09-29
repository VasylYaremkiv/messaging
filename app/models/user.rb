class User
  include Mongoid::Document
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  CUSTOMER = 'customer'
  ADMIN    = 'admin'

  PASSWORD = 'secret'

  ## Database authenticatable
  field :email,              type: String, default: ""
  field :username,           type: String, default: ""
  field :encrypted_password, type: String, default: ""

  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String

  ## Confirmable
  # field :confirmation_token,   type: String
  # field :confirmed_at,         type: Time
  # field :confirmation_sent_at, type: Time
  # field :unconfirmed_email,    type: String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    type: String # Only if unlock strategy is :email or :both
  # field :locked_at,       type: Time


  field :role, type: String, default: CUSTOMER
  field :first_name, type: String
  field :last_name, type: String
  field :active, type: Boolean, default: true

  validates :username, presence: true, uniqueness: { case_sensitive: false }

  before_validation :generate_password

  def email_required?
    false
  end

  def email_changed?
    false
  end

  def admin?
    role == ADMIN
  end

  def name
    [first_name, last_name].compact.join(' ')
  end

  private

  def generate_password
    self.password ||= PASSWORD
  end

end
