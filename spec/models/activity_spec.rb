require 'rails_helper'

RSpec.describe Activity, type: :model do
  it 'accepts the factory' do
    expect(FactoryBot.build(:activity)).to be_valid
  end

  it 'rejects with empty content' do
    activity = described_class.new(content: '', user: FactoryBot.create(:user))
    expect(activity).not_to be_valid
  end

  it 'rejects with no user' do
    activity = described_class.new(content: 'This Is My Last Activity', user: nil)
    expect(activity).not_to be_valid
  end
end
