class CreateDetails < ActiveRecord::Migration
  def self.up
    create_table :details do |t|
      t.integer :step_id
      t.text :description
      

      t.timestamps
    end
  end

  def self.down
    drop_table :details
  end
end
