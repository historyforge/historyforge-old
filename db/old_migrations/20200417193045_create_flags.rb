class CreateFlags < ActiveRecord::Migration[6.0]
  def change
    create_table :flags do |t|
      t.references :flaggable, polymorphic: true
      t.references :user, foreign_key: true
      t.string :reason
      t.text :message
      t.text :comment
      t.references :resolved_by, foreign_key: { to_table: 'users' }
      t.datetime :resolved_at

      t.timestamps
    end
  end
end
