FactoryBot.define do
  factory :social_account do
    social_network { "GitHub" }
    user_name { "Foo" }
  end
end
