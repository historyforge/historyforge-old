class GoodbyeMapwarper < ActiveRecord::Migration[5.2]
  def up
    drop_table :gcps
    drop_table :my_maps
    drop_table :memberships
    drop_table :groups_maps
    drop_table :groups
    drop_table :maps
    drop_table :taggings
    drop_table :tags
    drop_table :comments
    drop_table :audits
  end

  def down
  end
end
