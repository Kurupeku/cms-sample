class CreateImpressionsTable < ActiveRecord::Migration[6.0]
  def change
    create_table :impressions, force: true do |t|
      t.string :impressionable_type
      t.integer :impressionable_id
      t.integer :user_id
      t.string :controller_name
      t.string :action_name
      t.string :view_name
      t.string :request_hash
      t.string :ip_address
      t.string :session_hash
      t.text :message
      t.text :referrer
      t.text :params
      t.timestamps
    end
    add_index :impressions, %i[impressionable_type message impressionable_id], name: 'impressionable_type_message_index', unique: false, length: { message: 255 }
    add_index :impressions, %i[impressionable_type impressionable_id request_hash], name: 'poly_request_index', unique: false
    add_index :impressions, %i[impressionable_type impressionable_id ip_address], name: 'poly_ip_index', unique: false
    add_index :impressions, %i[impressionable_type impressionable_id session_hash], name: 'poly_session_index', unique: false
    add_index :impressions, %i[controller_name action_name request_hash], name: 'controlleraction_request_index', unique: false
    add_index :impressions, %i[controller_name action_name ip_address], name: 'controlleraction_ip_index', unique: false
    add_index :impressions, %i[controller_name action_name session_hash], name: 'controlleraction_session_index', unique: false
    add_index :impressions, %i[impressionable_type impressionable_id params], name: 'poly_params_request_index', unique: false, length: { params: 255 }
    add_index :impressions, :user_id

    add_column :articles, :impressions_count, :integer, null: false, default: 0
    add_column :articles, :comments_count, :integer, null: false, default: 0
  end
end
