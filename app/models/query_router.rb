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
          Movie.create(:title => movie.title, :release_date => movie.release_date)
        end
      end
    end
  end


  def self.merge_all_scattered_fragments
    QueryRouter.all.each do |x|
      sync_scattered_fragment(x.fragment_id)
    end
  end


  def self.transfer_fragment(fragment_id, source_site_id, target_site_id)
    ApplicationRecord.establish_connection_to_site(source_site_id)
    fragment = Movie.find_by_year(fragment_id)
    movie_array = fragment.to_a
    fragment.delete_all
    ApplicationRecord.establish_connection_to_site(target_site_id)
    movie_array.each do |movie|
      Movie.create(:title => movie.title, :release_date => movie.release_date)
    end
    update_query_router(fragment_id, target_site_id)
  end

  def self.find_optimal_site(fragment_id, alpha, beta)
    # logic to refresh site_id in site fragment data table

    logs = AccessLog.fragment_accesses(fragment_id, beta)

    total_accesses = logs.count
    total_volume = logs.pluck(:volume).sum

    total_average_volume = total_volume/total_accesses

    total_write_volume = logs.select{|x| x.rw==1}.pluck(:volume).sum


    site_access_counts = Hash.new(0)
    site_volume_transferred = Hash.new(0)
    site_write_volume_transferred = Hash.new(0)

    logs.each do |log|
      site_access_counts[log.site_id] = site_access_counts[log.site_id] + 1
      site_volume_transferred[log.site_id] = site_volume_transferred[log.site_id] + log.volume
      if log.rw==1
        site_write_volume_transferred[log.site_id] = site_write_volume_transferred[log.site_id] + log.volume
      end
    end

    # sites with minimum number of access count alpha
    frequent_sites = site_volume_transferred.select{|k,v| v > alpha}.keys

    candidate_sites = []
    frequent_sites.each do | site_id|
      #sites whos average volume transfer with fragment exceeds the overall overage volume transfer
      if site_volume_transferred[site_id]/site_access_counts[site_id] >total_average_volume
        candidate_sites << site_id
      end
    end

    if candidate_sites.empty?
      return
    elsif candidate_sites.length==1
      return candidate_sites.first
    else
      return site_write_volume_transferred.key(site_write_volume_transferred.values.max)
    end

  end


  def self.optimize_fragment_site( fragment_id, current_site)
    alpha = 5
    beta = 10
    target = find_optimal_site( fragment_id, alpha, beta)
    if target == current_site
      return
    else
      transfer_fragment(fragment_id, current_site, target)
    end
  end


end
