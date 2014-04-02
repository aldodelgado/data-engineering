class CreateTemps < ActiveRecord::Migration
  def change
    create_table :temps do |t|
      t.string :purchaser_name, default: ''
      t.string :item_description, default: ''
      t.string :item_price, default: ''
      t.string :purchase_count, default: ''
      t.string :merchant_address, default: ''
      t.string :merchant_name, default: ''
      t.timestamps
    end
  end
end
