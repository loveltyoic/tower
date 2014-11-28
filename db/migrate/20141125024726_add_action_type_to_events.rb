class AddActionTypeToEvents < ActiveRecord::Migration
  def change
    add_column :events, :action_type, :string
  end
end
