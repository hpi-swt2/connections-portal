FactoryBot.define do
  factory :social_account do
    social_network { random_social_network }
    user_name { random_name }
  end
end

def random_social_network
  ["GitHub", "Facebook", "Twitter"].sample
end

def random_name
  ('a'..'z').to_a.shuffle.join
end
