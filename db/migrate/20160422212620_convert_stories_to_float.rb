class ConvertStoriesToFloat < ActiveRecord::Migration[4.2]
  def change
    change_column :buildings, :stories, :float
  end
end
