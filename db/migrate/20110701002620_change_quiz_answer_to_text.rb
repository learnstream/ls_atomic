class ChangeQuizAnswerToText < ActiveRecord::Migration
  def self.up
    change_column :answers, :text, :text, :limit => nil
  end

  def self.down
    change_column :answers, :text, :string
  end
end
