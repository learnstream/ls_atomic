class AddCurrentTokenToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :active_token_id, :integer
    add_index :users, :active_token_id
  end

  def self.down
    remove_column :users, :active_token_id  
  end
end
