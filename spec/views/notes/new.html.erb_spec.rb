require 'rails_helper'

RSpec.describe "notes/new", type: :view do
  before(:each) do
    assign(:note, FactoryBot.build(:note))
  end

  it "renders new note form" do
    render
    expect(rendered).to have_css 'form', count: 1
    expect(rendered).to have_css "form[method=post][action=\"#{notes_path}\"]"
    expect(rendered).to have_css "input[type=submit]"
  end
end
