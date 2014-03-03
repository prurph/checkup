class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.references :tag, index: true
      t.integer :duration, default: 0
      t.timestamps
    end
  end
end
