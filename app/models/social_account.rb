class SocialAccount < ApplicationRecord
    validates :social_network, presence: true
    validates :user_name, presence: true
end
