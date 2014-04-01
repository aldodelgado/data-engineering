class CreateMerchants < ActiveRecord::Migration
  def change
    create_table :merchants do |t|
      t.string :name, default: ''
      t.string :address, default: ''
      t.boolean :active, default: true
      t.timestamps
    end
  end
end
