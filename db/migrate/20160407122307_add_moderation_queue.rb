class AddModerationQueue < ActiveRecord::Migration
  def change

    Role.where(name: 'census taker').first_or_create
    Role.where(name: 'builder').first_or_create

    change_table :census_records do |t|
      t.references :created_by, index: true
      t.references :reviewed_by, index: true
      t.datetime :reviewed_at
    end
    change_table :buildings do |t|
      t.references :created_by, index: true
      t.references :reviewed_by, index: true
      t.datetime :reviewed_at
    end

    add_foreign_key :census_records, :users, column: :created_by_id
    add_foreign_key :census_records, :users, column: :reviewed_by_id

    add_foreign_key :buildings, :users, column: :created_by_id
    add_foreign_key :buildings, :users, column: :reviewed_by_id

    execute "update census_records set reviewed_at=updated_at"
    execute "update buildings set reviewed_at=updated_at"

  end
end
