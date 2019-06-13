class AddIndexesToMemberships < ActiveRecord::Migration[4.2]
  def self.up
    add_index :memberships, [:user_id, :group_id], :unique =>true
    add_index :memberships, :user_id
  end

  def self.down
     remove_index :memberships, :user_id
    remove_index :memberships, [:user_id, :group_id]
  end
end
