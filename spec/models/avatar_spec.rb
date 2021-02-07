require 'rails_helper'

RSpec.describe Avatar, type: :model do
  let(:user) { FactoryBot.create :user }

  it 'is valid using a factory' do
    expect(FactoryBot.build(:avatar)).to be_valid
  end

  it 'is not valid without a file' do
    expect(FactoryBot.build(:avatar, file: nil)).not_to be_valid
  end

  it 'is not valid without a filename' do
    expect(FactoryBot.build(:avatar, filename: nil)).not_to be_valid
  end

  it 'is not valid without a filesize' do
    expect(FactoryBot.build(:avatar, filesize: nil)).not_to be_valid
  end

  it 'is not valid if it is bigger than 5MiB' do
    expect(FactoryBot.build(:avatar, filesize: 5.megabytes + 1)).not_to be_valid
  end

  it 'is not valid with a rational filesize' do
    expect(FactoryBot.build(:avatar, filesize: 10.5)).not_to be_valid
  end

  it 'is not valid without a mime type' do
    expect(FactoryBot.build(:avatar, mime_type: nil)).not_to be_valid
  end

  it 'is not valid with an arbitrary mime type' do
    expect(FactoryBot.build(:avatar, mime_type: 'application/pdf')).not_to be_valid
  end
end
