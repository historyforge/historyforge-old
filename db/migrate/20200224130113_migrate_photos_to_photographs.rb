class MigratePhotosToPhotographs < ActiveRecord::Migration[6.0]
  def change
    create_join_table :photographs, :buildings
    create_join_table :photographs, :people
    reversible do |dir|
      dir.up do
        Photo.find_each do |photo|
          p = Photograph.new
          p.building_ids = photo.building_ids.uniq
          p.description = photo.caption
          p.date_text = photo.year_taken

          filename = Rails.root.join 'public', 'photos', photo.id.to_s, 'original', photo.photo_file_name
          if File.exists?(filename)
            file = File.open(filename)
            p.file.attach io: file, filename: photo.photo_file_name
            p.save
            p.update_column :created_at, photo.created_at
          end
        end
      end
    end
  end
end
