class Rename < ActiveRecord::Migration[5.2]
  def change
    rename_table :central_access_log, :access_log
  end
end
