class CreateUploads < ActiveRecord::Migration
  def change
    create_table :uploads do |t|
      t.string :file
      t.boolean :process, default: false
      t.integer :created_by

      t.timestamps
    end
  end
end
