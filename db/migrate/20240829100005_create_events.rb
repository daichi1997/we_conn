class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.references :user ,       null: false,foreign_kye: true
      t.string     :title,       null: false
      t.text       :description, null: false
      t.datetime   :start_time,  null: false
      t.string     :location,    null: false
      t.integer    :tag_id,      null: false
      t.timestamps
    end
  end
end
