class AddBuildingNotes < ActiveRecord::Migration
  def change
    add_column :buildings, :notes, :text
  end
end
