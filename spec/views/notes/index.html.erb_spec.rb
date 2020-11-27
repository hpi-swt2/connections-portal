require 'rails_helper'

RSpec.describe "notes/index", type: :view do
  before(:each) do
    @notes = assign(:notes, FactoryBot.create_list(:note, 3))
  end

  it "renders a list of notes" do
    render
    @notes.each do |note|
      expect(rendered).to match note.title
      expect(rendered).to match note.content
    end
  end
end
