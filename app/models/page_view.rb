class PageView < Sequel::Model
  HASHABLE_ATTRIBUTES = [:id, :url, :referrer, :created_at]

  def self.generate_hash(attributes = {})
    normalized_hash = attributes
      .symbolize_keys
      .slice(*HASHABLE_ATTRIBUTES)  # remove unwanted keys and ensure correct order
      .delete_if {|key,value| value.nil?}     # remove nil attributes
    Digest::MD5.hexdigest(normalized_hash.to_s)
  end

  def self.top_pages(start_date, end_date)
    self
      .group_and_count(:url, :creation_date)
      .where(creation_date: start_date.to_date..end_date.to_date)
      .order(Sequel.desc(:creation_date), Sequel.desc(:count))
      .to_a
      .group_by {|row| row[:creation_date]}
  end

  def self.top_referrers(start_date, end_date)
    top_referrers_by_date = top_pages(start_date, end_date).map do |date, pages|
      top10_pages = pages.take(10)
      top10_urls = top10_pages.map {|page| page[:url]}
      referrers = self
        .group_and_count(:url, :referrer)
        .where(creation_date: date, url: top10_urls)
        .order(Sequel.desc(:count))
        .to_a
        .group_by {|row| row[:url]}
        .map do |url, referrers|
          {
            url: url,
            visits: top10_pages.detect {|page| page[:url] == url}[:count],
            referrers: referrers
          }
        end
      [date, referrers]
    end
    Hash[*top_referrers_by_date.flatten(1)]
  end

end
