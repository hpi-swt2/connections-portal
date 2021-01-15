# The social account record represents a account at a social network where the  user is registered.
class SocialAccount < ApplicationRecord
  validates :social_network, presence: true
  validates :user_name, presence: true
end
