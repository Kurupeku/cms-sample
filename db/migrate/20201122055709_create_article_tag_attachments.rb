class CreateArticleTagAttachments < ActiveRecord::Migration[6.0]
  def change
    create_table :article_tag_attachments do |t|
      t.references :article, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true

      t.timestamps
    end
  end
end
