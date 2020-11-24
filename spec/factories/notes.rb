FactoryBot.define do
  factory :note do
    # https://github.com/thoughtbot/factory_bot/blob/master/GETTING_STARTED.md#inline-sequences
    sequence(:title) { |n| "Note #{n}" }
    # https://github.com/thoughtbot/factory_bot/blob/master/GETTING_STARTED.md#dependent-attributes
    content { "The content of #{title.downcase}" }
    # https://github.com/thoughtbot/factory_bot/blob/master/GETTING_STARTED.md#implicit-definition
    user factory: :user
  end
end
