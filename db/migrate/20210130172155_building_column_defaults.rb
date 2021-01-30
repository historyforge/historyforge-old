class BuildingColumnDefaults < ActiveRecord::Migration[6.0]
  def change
    # t.string "city", default: "Ithaca", null: false
    # t.string "state", default: "NY", null: false
    # t.string "postal_code", default: "14850", null: false

    change_column_default :buildings, :city, from: 'Ithaca', to: nil
    change_column_default :buildings, :state, from: 'NY', to: nil
    change_column_default :buildings, :postal_code, from: '14850', to: nil

  end
end
