class PhotographWorkflowFields < ActiveRecord::Migration[6.0]
  def change
    change_table :photographs do |t|
      t.references :reviewed_by, foreign_key: { to_table: :users }, after: :created_by_id
      t.datetime :reviewed_at, after: :reviewed_by_id
    end
  end
end
