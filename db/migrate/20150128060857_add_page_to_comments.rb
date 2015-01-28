class AddPageToComments < ActiveRecord::Migration
  def change
    add_column :comments, :page, :integer
  end
end
