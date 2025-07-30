class CreateTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :transactions do |t|
      t.decimal :amount
      t.string :description
      t.date :date
      t.integer :transaction_type
      t.references :user, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.text :notes

      t.timestamps
    end
  end
end
