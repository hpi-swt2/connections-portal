class NotesController < ApplicationController
  before_action :set_note, only: %i[show edit update destroy]

  # GET /notes
  def index
    @notes = current_user.notes
  end

  # GET /notes/1
  def show; end

  # GET /notes/new
  def new
    @note = Note.new
  end

  # GET /notes/1/edit
  def edit; end

  # POST /notes
  def create
    @note = Note.new(note_params)
    @note.creator_user_id = current_user.id
    if @note.save
      redirect_to @note, notice: I18n.t('confirmation.resource_creation', resource: Note)
    else
      render :new
    end
  end

  # PATCH/PUT /notes/1
  def update
    if @note.update(note_params)
      redirect_to @note, notice: I18n.t('confirmation.resource_update', resource: Note)
    else
      render :edit
    end
  end

  # DELETE /notes/1
  def destroy
    @note.destroy
    redirect_to notes_url, notice: I18n.t('confirmation.resource_deletion', resource: Note)
  end

  private # Everything below this line is private

  # Use callbacks to share common setup or constraints between actions.
  def set_note
    @note = Note.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def note_params
    params.require(:note).permit(:title, :content, :user_id)
  end
end
