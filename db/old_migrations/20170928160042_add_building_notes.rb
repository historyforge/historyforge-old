class AddBuildingNotes < ActiveRecord::Migration[4.2]
  def change
    add_column :buildings, :notes, :text
  end
end
