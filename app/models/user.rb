# An application user, uses the `devise` library
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # https://github.com/heartcombo/devise/wiki/
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  # The dependent: option allows to specify that associated records should be deleted when the owner is deleted
  # https://api.rubyonrails.org/classes/ActiveRecord/Associations/ClassMethods.html >> Deleting from Associations
  has_many :notes, dependent: :delete_all

  VALID_STATUS_LIST = %w[available working].freeze

  validates :username, :email, presence: true
  validates :current_status, inclusion: { in: VALID_STATUS_LIST }

  after_initialize :init

  attribute :current_status, :string, default: "available"

  def init
    self.username ||= email.split('@', 2)[0]
  end

  def select_status_list
    VALID_STATUS_LIST.map { |status| [I18n.t("user.status.#{status}"), status] }
  end
end
