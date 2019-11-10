class QueryRouter < ApplicationRecord
  self.table_name = 'fragment_site_data'


  def self.find_site_of_fragment(fragment_id)
    establish_connection(:central)
    fragment_detail = QueryRouter.where(fragment_id: fragment_id).last
    if fragment_detail
      return fragment_detail.site_id
    else
      return nil
    end
  end

  def self.update_query_router(fragment_id, site_id)
    establish_connection(:central)
    QueryRouter.first_or_create(fragment_id).update(site_id: site_id)
  end

  def self.relocate_fragment(fragment_id, target_site_id)
    site_id = QueryRouter.find_by_fragment_id(fragment_id).try(:site_id)

    ApplicationRecord.establish_connection_to_site(site_id)

    fragment = Movie.find_by_year(fragment_id).to_a
    update_query_router(fragment_id, target_site_id)
  end

  def self.merge_scattered_fragment(fragment_id)
    establish_connection(:central)
    target_site_id = QueryRouter.find_by_fragment_id(fragment_id).try(:site_id)
    if target_site_id
      fragment = []
      (1..3).to_a.each do |site_id|
        ApplicationRecord.establish_connection_to_site(site_id)
        movies = Movie.find_by_year(fragment_id)
        fragment.push(movies.to_a)
        movies.delete_all
      end
      ApplicationRecord.establish_connection_to_site(target_site_id)
      fragment.each do |fragment_piece|
        fragment_piece.each do |movie|
          Movie.create(title: movie.title, release_date: movie.release_date)
        end
      end
    end
  end

  def self.merge_all_scattered_fragments
    QueryRouter.all.each do |x|
      merge_scattered_fragment(x.fragment_id)
    end
  end

end
