require 'rails_helper'

RSpec.describe "/notes", type: :request do
  let(:user) { FactoryBot.create :user }
  let(:valid_attributes) do
    FactoryBot.attributes_for(
      :note,
      user_id: user.id,
      creator_user_id: user.id
    )
  end
  let(:invalid_attributes) { FactoryBot.attributes_for :note, title: '' }

  before { sign_in user }

  describe "GET /index" do
    it "renders a successful response" do
      Note.create! valid_attributes
      get notes_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      note = Note.create! valid_attributes
      get note_url(note)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_note_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "render a successful response" do
      note = Note.create! valid_attributes
      get edit_note_url(note)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Note" do
        expect do
          post notes_url, params: { note: valid_attributes }
        end.to change(Note, :count).by(1)
      end

      it "redirects to the created note" do
        post notes_url, params: { note: valid_attributes }
        expect(response).to redirect_to(note_url(Note.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Note" do
        expect do
          post notes_url, params: { note: invalid_attributes }
        end.to change(Note, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post notes_url, params: { note: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) do
        { title: "#{valid_attributes[:title]} updated!" }
      end

      it "updates the requested note" do
        note = Note.create! valid_attributes
        patch note_url(note), params: { note: new_attributes }
        note.reload
        expect(note.title).to eq(new_attributes[:title])
      end

      it "redirects to the note" do
        note = Note.create! valid_attributes
        patch note_url(note), params: { note: new_attributes }
        note.reload
        expect(response).to redirect_to(note_url(note))
      end
    end

    context "with invalid parameters" do
      it "renders a successful response (i.e. to display the 'edit' template)" do
        note = Note.create! valid_attributes
        patch note_url(note), params: { note: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested note" do
      note = Note.create! valid_attributes
      expect do
        delete note_url(note)
      end.to change(Note, :count).by(-1)
    end

    it "redirects to the notes list" do
      note = Note.create! valid_attributes
      delete note_url(note)
      expect(response).to redirect_to(notes_url)
    end
  end
end
