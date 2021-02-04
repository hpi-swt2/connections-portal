# An application user, uses the `devise` library
class User < ApplicationRecord
  # Every user can have multiple social accounts like GitHub, Telegram, ...
  has_many :social_accounts, dependent: :delete_all

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # https://github.com/heartcombo/devise/wiki/
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  # The dependent: option allows to specify that associated records should be deleted when the owner is deleted
  # https://api.rubyonrails.org/classes/ActiveRecord/Associations/ClassMethods.html >> Deleting from Associations
  has_many :notes, dependent: :delete_all
  has_many :activities, dependent: :delete_all
  has_many :call_participants, dependent: :delete_all, inverse_of: :user
  has_many :jitsi_calls, through: :call_participants

  # as we do not need to work with the relationship models as independent entities, `has_and_belongs_to_many` is fine
  # https://guides.rubyonrails.org/association_basics.html#choosing-between-has-many-through-and-has-and-belongs-to-many
  # rubocop:disable Rails/HasAndBelongsToMany
  has_many :friendships, :dependent => :destroy
  has_many :contacts, :through => :friendships, :source => :user

  has_and_belongs_to_many :contact_requests,
                          class_name: 'User',
                          join_table: 'users_contact_requests',
                          foreign_key: 'requested_user_id',
                          association_foreign_key: 'requesting_user_id'
  # rubocop:enable Rails/HasAndBelongsToMany

  VALID_STATUS_LIST = %w[available working free_for_chat offline nice_to_meet_you].freeze

  # class methods
  def self.select_status_list
    VALID_STATUS_LIST.map { |status| [I18n.t("user.status.#{status}"), status] }
  end

  VALID_STATUS_LIST.each do |status|
    define_singleton_method :"status_#{status}" do
      status
    end
  end

  def self.filter_status
    status_nice_to_meet_you
  end

  validates :username, :email, presence: true
  validates :current_status, inclusion: { in: VALID_STATUS_LIST }

  after_initialize :init

  attribute :current_status, :string, default: User.status_available

  scope :with_status, ->(status) { where(current_status: status) }

  def init
    self.username ||= email.split('@', 2)[0]
  end

  def sent_contact_request?(user)
    (user.contact_requests.include? self) or (contacts.include? user)
  end

  def notes
    Note.where(creator_user_id: id)
  end

  def display_name
    [firstname, lastname].filter(&:present?).join(' ').presence || username
  end

  def self.search(search)
    if search.present?
      User.where('username LIKE ?', "%#{search}%").or(User.where('firstname LIKE ?', "%#{search}%"))
          .or(User.where('lastname LIKE ?', "%#{search}%")).or(User.where('email LIKE ?', "%#{search}%"))
    else
      User.all
    end
  end

  def name
    "#{firstname} #{lastname}"
  end
end
