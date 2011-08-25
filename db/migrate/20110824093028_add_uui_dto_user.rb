class AddUuiDtoUser < ActiveRecord::Migration
  def self.up
    add_column :users, :uuid, :string
  end

  def self.down
  end
end
