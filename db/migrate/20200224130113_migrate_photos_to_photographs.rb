class MigratePhotosToPhotographs < ActiveRecord::Migration[6.0]
  def change
    create_join_table :photographs, :buildings
    create_join_table :photographs, :people
  end
end
