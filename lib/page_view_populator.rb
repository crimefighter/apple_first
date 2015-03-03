require 'faker'

class PageViewPopulator
  NUMBER_OF_ENTRIES = Rails.env.test? ? 1000 : 1000000
  NUMBER_OF_DAYS = Rails.env.test? ? 2 : 10
  BATCH_SIZE = 1000
  NUMBER_OF_FAKE_URLS = 100
  MANDATORY = {
    urls: %w(
      http://apple.com
      https://apple.com
      https://www.apple.com
      http://developer.apple.com
      http://en.wikipedia.org
      http://opensource.org
    ),
    referrers: %w(
      http://apple.com
      https://apple.com
      https://www.apple.com
      http://developer.apple.com
    ) << nil
  }.freeze

  def self.populate!
    number_of_batches = NUMBER_OF_ENTRIES/BATCH_SIZE
    number_of_batches.times do |batch_number|
      populate_batch!(batch_number)
      puts "Populated batch #{batch_number+1} of #{number_of_batches}"
    end
  end

private
  def self.populate_batch!(batch_number = 0)
    base_row_id = batch_number * BATCH_SIZE + 1
    rows = BATCH_SIZE.times.map do |row_number|
      row = {
        id: base_row_id + row_number,
        url: generate_url(batch_number),
        created_at: generate_created_at
      }
      row[:referrer] = generate_referrer(batch_number, row[:url])
      row[:creation_date] = row[:created_at].to_date
      row[:hash] = PageView.generate_hash(row)
      row
    end
    PageView.db.transaction do
      PageView.dataset.multi_insert rows
    end
  end

  # Generate url for PageView
  # Shuffles mandatory urls for first batch, then adds faker
  def self.generate_url batch_number
    if batch_number.zero?
      MANDATORY[:urls]
    else
      fake_urls
    end.sample
  end

  # Generate referrer for PageView
  # Shuffles mandatory referrers for first batch, then adds faker
  # Makes sure referrer is not the same as url
  def self.generate_referrer(batch_number, url)
    if batch_number.zero?
      MANDATORY[:referrers].reject do |referrer|
        referrer == url
      end.sample
    else
      fake_referrer = fake_urls.sample
      # if fake referrer happens to be the same as url, return null instead
      fake_referrer == url ? nil : fake_referrer
    end
  end

  def self.generate_created_at
    rand(NUMBER_OF_DAYS).days.ago.midnight + rand(1440).minutes
  end

  def self.fake_urls
    @@fake_urls ||= NUMBER_OF_FAKE_URLS.times.map { Faker::Internet.url } +
      MANDATORY.values.flatten.compact.uniq
  end
end
