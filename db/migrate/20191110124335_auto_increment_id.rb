class AutoIncrementId < ActiveRecord::Migration[5.2]
  def change
    @connection = ActiveRecord::Base.establish_connection(:site_x).connection
    change_column :movies, :id, :integer, limit: 8, auto_increment: true

    @connection = ActiveRecord::Base.establish_connection(:site_y).connection
    change_column :movies, :id, :integer, limit: 8, auto_increment: true

    @connection = ActiveRecord::Base.establish_connection(:site_z).connection
    change_column :movies, :id, :integer, limit: 8, auto_increment: true


    @connection = ActiveRecord::Base.establish_connection(:central).connection
  end
end

