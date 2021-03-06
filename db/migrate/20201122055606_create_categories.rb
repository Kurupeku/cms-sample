class CreateCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :categories do |t|
      t.string :name, null: false, default: ''
      t.integer :articles_count, null: false, default: 0

      t.timestamps
    end

    add_reference :articles, :category, foreign_key: true
    add_reference :categories, :parent, index: true, unsigned: true, default: nil, after: :state
    add_foreign_key :categories, :categories, column: :parent_id
  end
end
