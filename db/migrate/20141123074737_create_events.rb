class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|

      t.timestamps
      t.string :type
      t.string :action
      t.references :project
      t.references :initiator
      t.references :target, polymorphic: true
    end
  end
end
