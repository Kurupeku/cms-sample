class CreateArticles < ActiveRecord::Migration[6.0]
  def change
    create_table :articles do |t|
      t.string :title, null: false, default: ''
      t.string :opening_sentence, default: ''
      t.integer :status, null: false, default: 0
      t.integer :article_type, null: false, default: 0
      t.string :slug, null: false, index: true, unique: true
      t.datetime :published_at, index: true

      t.timestamps
    end
  end
end
