class CreateCategories < ActiveRecord::Migration[8.0]
  def change
    create_table :categories do |t|
      t.string :name
      t.string :icon
      t.string :color
      t.references :user, null: false, foreign_key: true
      t.integer :parent_id
      t.integer :category_type
      t.integer :position

      t.timestamps
    end
  end
end
