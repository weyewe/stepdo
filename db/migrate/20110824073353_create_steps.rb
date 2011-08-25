class CreateSteps < ActiveRecord::Migration
  def self.up
    create_table :steps do |t|
      t.integer  "post_id"
      t.integer  "order"
      t.string   "title"
      t.text     "description"

      t.timestamps
    end
  end

  def self.down
    drop_table :steps
  end
end
