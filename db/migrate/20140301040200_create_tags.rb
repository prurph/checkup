class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.references :category, index: true
      t.boolean :active, default: true
      t.integer :routine, default: -1
      t.text    :name
      t.integer :current_event_id, default: -1
      t.timestamps
    end
  end
end
