class CreateSettings < ActiveRecord::Migration[6.0]
  def change
    create_table :settings do |t|
      t.string :site_title, null: false, default: 'Sample Blog'
      t.boolean :anable_main_cover, null: false, default: false
      t.boolean :anable_recent_comments, null: false, default: false
      t.boolean :anable_recent_popular, null: false, default: false
      t.integer :recent_popular_span, null: false, default: 7

      t.timestamps
    end
  end
end
