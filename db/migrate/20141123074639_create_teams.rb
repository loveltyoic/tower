class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|

      t.timestamps
      t.string :name
    end
  end
end
