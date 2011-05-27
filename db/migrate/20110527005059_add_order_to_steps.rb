class AddOrderToSteps < ActiveRecord::Migration
  def self.up
    add_column :steps, :order_number, :integer
  end

  def self.down
    remove_column :steps, :order_number
  end
end
