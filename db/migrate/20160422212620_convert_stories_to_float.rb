class ConvertStoriesToFloat < ActiveRecord::Migration
  def change
    change_column :buildings, :stories, :float
  end
end
