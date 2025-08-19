class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :name
      t.string :category
      t.boolean :vegetarian
      t.decimal :price
      t.string :image

      t.timestamps
    end
  end
end
