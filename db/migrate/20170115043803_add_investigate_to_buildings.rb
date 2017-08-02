class AddInvestigateToBuildings < ActiveRecord::Migration
  def change
    add_column :buildings, :investigate, :boolean, default: false
    add_column :buildings, :investigate_reason, :string
    Building.update_all investigate: false
  end
end
