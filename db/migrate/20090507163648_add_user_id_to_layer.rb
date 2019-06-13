class AddUserIdToLayer < ActiveRecord::Migration[4.2]
  def self.up
      add_column :layers, :user_id, :integer
  end

  def self.down
      remove_column :layers, :user_id
  end
end
