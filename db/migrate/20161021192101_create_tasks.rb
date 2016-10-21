class CreateTasks < ActiveRecord::Migration[5.0]
  def change
    create_table :tasks do |t|
      t.string :name
      t.string :icon_name
      t.string :icon_path
      t.string :section
      t.string :template_name
      t.string :template_url
      t.string :prereqs
      t.string :description
      t.integer :project_id
      t.integer :parent_id
      t.integer :sort_order
      t.integer :state, default: 0
      t.timestamps
    end
    add_index :tasks, :project_id
    add_index :tasks, :parent_id
  end
end
