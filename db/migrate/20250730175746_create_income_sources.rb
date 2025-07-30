class CreateIncomeSources < ActiveRecord::Migration[8.0]
  def change
    create_table :income_sources do |t|
      t.string :name
      t.decimal :amount
      t.integer :frequency
      t.references :user, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.date :start_date
      t.date :end_date
      t.boolean :active

      t.timestamps
    end
  end
end
