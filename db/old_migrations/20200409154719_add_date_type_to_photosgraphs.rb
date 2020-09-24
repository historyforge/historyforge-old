class AddDateTypeToPhotosgraphs < ActiveRecord::Migration[6.0]
  def change
    add_column :photographs, :date_type, :integer, default: 0
  end
end
