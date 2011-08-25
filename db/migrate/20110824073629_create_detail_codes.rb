class CreateDetailCodes < ActiveRecord::Migration
  def self.up
    create_table :detail_codes do |t|
      t.integer :step_id
      t.text :code
    

      t.timestamps
    end
  end

  def self.down
    drop_table :detail_codes
  end
end
