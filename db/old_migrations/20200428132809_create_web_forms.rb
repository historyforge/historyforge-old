class CreateWebForms < ActiveRecord::Migration[6.0]
  def change
    create_table :contacts do |t|
      t.jsonb :data

      t.timestamps
    end
  end
end
