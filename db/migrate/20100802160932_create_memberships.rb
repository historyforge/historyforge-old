class CreateMemberships < ActiveRecord::Migration[4.2]
  def self.up
    create_table :memberships do |t|
      t.column "user_id",    :integer
      t.column "group_id",   :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :memberships
  end
end
