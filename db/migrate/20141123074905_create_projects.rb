class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|

      t.timestamps
      t.string :name
      t.references :team
    end
  end
end
