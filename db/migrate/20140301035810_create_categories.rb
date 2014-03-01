class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.references :user, index: true
      t.boolean :active
      t.datetime :inactive_at
      t.text :color
      t.text :title
      t.timestamps
    end
  end
end
