FactoryBot.define do
  factory :activity do
    association :user
    content { random_content }
  end
end

def random_content
  ('a'..'z').to_a.shuffle.join
end
