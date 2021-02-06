class CreateAvatars < ActiveRecord::Migration[6.0]
  def change
    create_table :avatars do |t|
      t.string :filename
      t.integer :filesize
      t.string :mime_type
      t.binary :file
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_default_avatars
  end

  private

  def add_default_avatars
    file = File.open(Rails.root.join('app/assets/images/default_avatar.png'), 'rb')
    content = file.read
    size = file.size
    file.close
    User.all.each do |user|
      Avatar.create!(
        file: content, filename: 'default_avatar.png',
        filesize: size, mime_type: 'image/png',
        user_id: user.id
      )
    end
  end
end
