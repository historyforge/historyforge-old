class CmsMigration < ActiveRecord::Migration[6.0]
  def change
    create_table :cms_menus do |t|
      t.string :name
      t.json :data
      t.timestamps
    end

    create_table :cms_menu_items do |t|
      t.references :menu, index: true
      t.string :ancestry, index: true
      t.string :title
      t.string :url
      t.boolean :is_external
      t.boolean :show_as_expanded
      t.boolean :enabled
      t.integer :position
      t.json :data
      t.timestamps
    end

    create_table :cms_pages do |t|
      t.string :type, default: 'Cms::Page'
      t.string :url_path
      t.string :controller
      t.string :action
      t.boolean :published, default: true
      t.boolean :visible, default: false
      t.json :data
      t.timestamps
    end
    add_index :cms_pages, :url_path
    add_index :cms_pages, [:controller, :action]

    create_table :cms_page_widgets do |t|
      t.references :cms_page, index: true, foreign_key: true
      t.string   :type
      t.jsonb    :data
      t.timestamps null: false
    end
  end
end
