class AddFragmentSiteTable < ActiveRecord::Migration[5.2]
  def change
    create_table :fragment_site_data do |t|
      t.integer :site_id
      t.integer :fragment_id

      t.timestamps
    end
  end
end
