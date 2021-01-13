require 'rails_helper'

RSpec.describe 'notes/new', type: :view do
  before do
    assign(:note, FactoryBot.build(:note))
  end

  it 'renders new note form' do
    render
    expect(rendered).to have_css 'form', count: 1
    expect(rendered).to have_css "form[method=post][action=\"#{notes_path}\"]"
  end

  it 'renders a submit button' do
    render
    expect(rendered).to have_css 'input[type=submit]', count: 1
  end
end
