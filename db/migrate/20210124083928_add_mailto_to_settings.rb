class AddMailtoToSettings < ActiveRecord::Migration[6.0]
  def change
    add_column :settings, :mail_to, :string
  end
end
