# Migration to create pastes table
class CreatePastes < ActiveRecord::Migration[6.1]
  def change
    create_table :pastes do |t|
      t.text :content
      t.boolean :private, null: false, default: false
      t.integer :owner
      t.timestamps
    end
    add_reference :pastes, :owner, foreign_key: { to_table: :users }
  end
end
