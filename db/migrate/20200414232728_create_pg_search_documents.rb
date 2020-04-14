class CreatePgSearchDocuments < ActiveRecord::Migration[6.0]
  def self.up
    say_with_time("Creating table for pg_search multisearch") do
      create_table :pg_search_documents do |t|
        t.text :content
        t.belongs_to :searchable, polymorphic: true, index: true
        t.timestamps null: false
      end
    end
    say_with_time("Indexing existing census records") do
      PgSearch::Multisearch.rebuild(Census1900Record, false)
      PgSearch::Multisearch.rebuild(Census1910Record, false)
      PgSearch::Multisearch.rebuild(Census1920Record, false)
      PgSearch::Multisearch.rebuild(Census1930Record, false)
    end
  end

  def self.down
    say_with_time("Dropping table for pg_search multisearch") do
      drop_table :pg_search_documents
    end
  end
end
