class CreateLogs < ActiveRecord::Migration[6.0]
  def change
    create_table :logs do |t|
      t.string :product_name
      t.integer :quantity

      t.timestamps
    end
  end
end
