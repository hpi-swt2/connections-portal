# The social account record represents a account at a social network where the  user is registered.
class SocialAccount < ApplicationRecord
  validates :social_network, presence: true
  validates :user_name, presence: true
end

NEXT: Write logic and test for filter that only returns visible_social_accounts! Then use it in view ...
We will also need to patch DB.
