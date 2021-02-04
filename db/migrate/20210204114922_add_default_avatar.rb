class AddDefaultAvatar < ActiveRecord::Migration[6.0]
  def up
    User.all.each do |user|
      next if user.avatar.attached?

      user.avatar.attach(
        io: File.open(
          Rails.root.join('app/assets/images/default_avatar.png')
        ), filename: 'default_avatar.png', content_type: 'image/png'
      )
      user.save
    end
  end
end
