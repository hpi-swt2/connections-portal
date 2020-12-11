class CreateSocialAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :social_accounts do |t|
      t.string :social_network
      t.string :user_name

      t.timestamps
    end
  end
end
