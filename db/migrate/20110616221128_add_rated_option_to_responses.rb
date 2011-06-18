class AddRatedOptionToResponses < ActiveRecord::Migration
  def self.up
    add_column :responses, :has_been_rated, :boolean, :default => 0
  end

  def self.down
    remove_column :responses, :has_been_rated  
  end
end
