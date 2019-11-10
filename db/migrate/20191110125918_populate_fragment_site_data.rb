class PopulateFragmentSiteData < ActiveRecord::Migration[5.2]
  def up
    (1900..2020).to_a.each do |year|
      QueryRouter.find_or_create_by(:fragment_id => year).update(:site_id => year % 3 + 1)
    end
  end
end
