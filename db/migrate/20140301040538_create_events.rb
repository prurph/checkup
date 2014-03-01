class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.references :tag, index: true
      t.time :duration
      t.timestamps
    end
  end
end
