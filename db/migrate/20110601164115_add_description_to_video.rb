class AddDescriptionToVideo < ActiveRecord::Migration
  def self.up
    add_column :videos, :description, :string
  end

  def self.down
    remove_column :videos, :description
  end
end
