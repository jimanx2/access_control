class CreateAccessControlModules < ActiveRecord::Migration
  def change
    create_table :access_control_modules do |t|
      t.string :name
      t.string :route_name

      t.timestamps
    end
  end
end
