class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|

      t.timestamps
      t.string :password_digest
      t.string :email
      t.string :name
    end
  end
end
