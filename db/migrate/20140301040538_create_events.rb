class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.references :tag, index: true
      t.integer :duration, default: 0
      t.datetime :started_at
      t.datetime :ended_at
      t.timestamps
    end
  end
end
