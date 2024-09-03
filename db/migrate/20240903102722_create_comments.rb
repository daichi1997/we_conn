class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.references :user,    null: false,foreign_key: true
      t.references :event,   null: false,foreign_key: true
      t.text       :content, null: false
      t.boolean    :liked_by_owner, default: false
      t.timestamps
    end
  end
end
