class CreateTodos < ActiveRecord::Migration
  def change
    create_table :todos do |t|

      t.timestamps
      t.string :name
      t.references :project
      t.references :assignee
      t.references :creator
      t.date :deadline
      t.integer :status, default: 0
    end
  end
end
