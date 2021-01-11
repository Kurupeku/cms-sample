class AddColumnToComments < ActiveRecord::Migration[6.0]
  def change
    add_column :comments, :number, :integer
    add_reference :comments, :parent, index: true, unsigned: true, default: nil, after: :state
    add_foreign_key :comments, :comments, column: :parent_id
  end
end
