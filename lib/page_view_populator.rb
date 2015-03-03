require 'faker'

class PageViewPopulator
  NUMBER_OF_ENTRIES = 1000000
  NUMBER_OF_DAYS = 10
  BATCH_SIZE = 1000
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
      puts "Populated batch #{batch_number} of #{number_of_batches}"
    end
  end

private
  def self.populate_batch!(batch_number = 0)
    base_row_id = batch_number * BATCH_SIZE + 1
    rows = BATCH_SIZE.times.map do |row_number|
      row = {
        id: base_row_id + row_number,
        url: MANDATORY[:urls].sample,
        created_at: rand(NUMBER_OF_DAYS+1).days.ago.midnight + rand(1440).minutes
      }
      row[:referrer] = MANDATORY[:referrers].reject do |referrer|
        referrer == row[:url]
      end.sample
      row[:creation_date] = row[:created_at].to_date
      row[:hash] = PageView.generate_hash(row)
      row
    end
    PageView.db.transaction do
      PageView.dataset.multi_insert rows
    end
  end
end
