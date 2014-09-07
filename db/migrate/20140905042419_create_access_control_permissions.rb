class CreateAccessControlPermissions < ActiveRecord::Migration
  def change
    create_table :access_control_permissions do |t|
      t.string :requester_type
      t.integer :requester_id
      t.string :route_path
      t.boolean :allow

      t.timestamps
    end
  end
end
