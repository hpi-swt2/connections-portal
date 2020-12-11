class SocialAccount < ApplicationRecord
    validates :social_network, presence: true, allow_blank: false
    validates :user_name, presence: true, allow_blank: false
end
