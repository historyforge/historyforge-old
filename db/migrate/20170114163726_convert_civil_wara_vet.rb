class ConvertCivilWaraVet < ActiveRecord::Migration
  def up
    rename_column :census_1910_records, :civil_war_vet, :civil_war_vet_old
    add_column :census_1910_records, :civil_war_vet, :string, limit: 2, default: nil
    Census1910Record.where(civil_war_vet_old: true).update_all(civil_war_vet: 'UA')
  end

  def down
    remove_column :census_1910_records, :civil_war_vet
    rename_column :census_1910_records, :civil_war_vet_old, :civil_war_vet
  end
end
