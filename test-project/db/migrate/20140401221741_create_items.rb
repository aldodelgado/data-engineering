class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.integer :merchant_id
      t.string :name, default: ''
      t.decimal :price, :precision => 8, :scale => 2
      t.boolean :active, default: true
      t.timestamps
    end
  end
end
