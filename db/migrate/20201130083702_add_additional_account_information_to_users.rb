class AddAdditionalAccountInformationToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :username, :string
    add_column :users, :firstname, :string
    add_column :users, :lastname, :string
    add_column :users, :place_of_residence, :string
    add_column :users, :birthdate, :date
  end
end
