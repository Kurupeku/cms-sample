class CreateComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      t.references :user, foreign_key: true
      t.references :article, null: false, foreign_key: true
      t.string :author_name, null: false, default: ''
      t.string :author_ip, null: false, default: ''
      t.string :author_url, null: false, default: ''
      t.string :author_agent, null: false, default: ''
      t.text :content, null: false, default: ''
      t.integer :status, null: false, default: 0

      t.timestamps
    end
  end
end
