class AddProfileToUser < ActiveRecord::Migration[4.2]
  def self.up
    add_column :users, :description, :text, :default => ""
  end

  def self.down
    remove_column :users, :description
  end
end
