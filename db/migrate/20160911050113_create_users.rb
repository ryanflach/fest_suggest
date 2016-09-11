class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.text :username
      t.text :access_token
      t.text :refresh_token
      t.datetime :token_expiry

      t.timestamps
    end
  end
end
