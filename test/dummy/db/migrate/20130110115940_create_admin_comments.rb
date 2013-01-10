class CreateAdminComments < ActiveRecord::Migration
  def change
    create_table :active_admin_comments do |t|
      t.string :resource_id, :null => false
      t.string :resource_type, :null => false
      t.references :author, :polymorphic => true
      t.string :namespace

      t.text :body
      t.timestamps
    end
    add_index     :active_admin_comments, [:namespace]
    add_index     :active_admin_comments, [:author_type, :author_id]
  end


end
