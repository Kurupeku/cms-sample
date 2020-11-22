class CreateTags < ActiveRecord::Migration[6.0]
  def change
    create_table :tags do |t|
      t.string :name, null: false, default: ''
      t.integer :articles_count, null: false, default: 0

      t.timestamps
    end
  end
end
