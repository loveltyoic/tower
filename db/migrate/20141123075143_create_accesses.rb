class CreateAccesses < ActiveRecord::Migration
  def change
    create_table :accesses do |t|

      t.timestamps
      t.references :project
      t.references :user
    end
  end
end
