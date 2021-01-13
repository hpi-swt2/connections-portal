require 'rails_helper'

RSpec.describe "notes/edit", type: :view do
  before do
    assign(:note, FactoryBot.create(:note))
  end

  it "renders the edit note form" do
    render
    expect(rendered).to have_css 'form', count: 1
    expect(rendered).to have_css "form[method=post][action=\"#{note_path(view_assigns[:note])}\"]"
  end

  it "renders a submit button" do
    render
    expect(rendered).to have_css "input[type=submit]"
  end
end
