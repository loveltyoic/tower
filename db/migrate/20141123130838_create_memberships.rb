class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|

      t.timestamps
      t.references :member
      t.references :team
    end
  end
end
