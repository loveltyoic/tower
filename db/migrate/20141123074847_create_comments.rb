class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|

      t.timestamps
      t.references :commentable, polymorphic: true
      t.text :content
      t.references :event
    end
  end
end
