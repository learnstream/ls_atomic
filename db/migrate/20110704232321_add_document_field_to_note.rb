class AddDocumentFieldToNote < ActiveRecord::Migration
  def self.up
    add_column :notes, :is_document, :boolean, :default => false
  end

  def self.down
    remove_column :notes, :is_document
  end
end
