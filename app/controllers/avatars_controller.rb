class AvatarsController < ApplicationController
  before_action :authenticate_user!

  def upload
    @avatar = Avatar.find_by(user_id: current_user.id) || Avatar.new
    file = params[:avatar][:file]
    @saved = @avatar.update(
      file: file.read,
      filename: file.original_filename,
      file_size: file.size,
      mime_type: file.content_type,
      user_id: current_user.id
    )

    respond_to { |format| return format.js }
  end

  def serve
    avatar = Avatar.find_by(user_id: params[:id])
    send_data(
      avatar.file,
      type: avatar.mime_type,
      filename: avatar.filename,
      disposition: :inline
    )
  end
end
