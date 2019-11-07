class AddAccessLogsToSiteYdb < ActiveRecord::Migration[5.2]
  def connection
    @connection = ActiveRecord::Base.establish_connection(:site_y).connection
  end

  def change
    create_table :access_log do |t|
      t.integer :site_id
      t.boolean :rw
      t.integer :fragment_id
      t.integer :volume

      t.timestamps
    end

    @connection = ActiveRecord::Base.establish_connection(:central).connection
  end
end
