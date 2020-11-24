require 'rails_helper'

RSpec.describe "notes/edit", type: :view do
  before(:each) do
    @note = FactoryBot.create(:note)
  end

  it "renders the edit note form" do
    render
    expect(rendered).to have_css 'form', count: 1
    expect(rendered).to have_css "form[method=post][action=\"#{note_path(@note)}\"]"
    expect(rendered).to have_css "input[type=submit]"
  end
end
