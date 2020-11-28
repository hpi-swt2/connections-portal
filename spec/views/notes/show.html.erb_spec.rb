require 'rails_helper'

RSpec.describe "notes/show", type: :view do
  before(:each) do
    assign(:note, FactoryBot.create(:note))
    render
  end

  it "shows the title of a note" do
    expect(rendered).to match view_assigns[:note].title
  end

  it "shows the content of a note" do
    expect(rendered).to match view_assigns[:note].content
  end

  it "shows the user that a note is connected to" do
    expect(rendered).to match view_assigns[:note].user.email
  end
end
