require 'rails_helper'

RSpec.describe "notes/show", type: :view do
  before(:each) do
    @note = FactoryBot.create(:note)
  end

  it "shows the details of a note" do
    render
    expect(rendered).to match @note.title
    expect(rendered).to match @note.content
    expect(rendered).to match @note.user.email
  end
end
