class CreateAccessControlModuleRoutes < ActiveRecord::Migration
  def change
    create_table :access_control_module_routes do |t|
      t.integer :module_id
      t.string :route_path

      t.timestamps
    end
  end
end
