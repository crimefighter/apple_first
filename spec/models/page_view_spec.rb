require 'rails_helper'

RSpec.describe PageView, type: :model do
  describe ".generate_hash" do
    context "referrer is not null" do
      it "generates hash correctly" do
        attributes = {
          id:1,
          url: 'http://apple.com',
          referrer: 'http://store.apple.com/us',
          created_at: Time.parse('2012-01-01'),
          hash: 'bfa4f1b5062009eb0eacbb906935cf34'
        }
        expect(PageView.generate_hash(attributes)).to eq attributes[:hash]
      end
    end
    context "referrer is null" do
      it "still generates hash correctly" do
        attributes = {
          id:1,
          url: 'http://apple.com',
          referrer: nil,
          created_at: Time.parse('2012-01-01'),
          hash: '2aed7266bbfe20d5cf972c30c0367f1e'
        }
        expect(PageView.generate_hash(attributes)).to eq attributes[:hash]
      end
    end
  end

  shared_examples "pages report" do
    it "returns data grouped by date" do
      desired_dates = [0, 1, 2].map do |n|
        n.days.ago.to_date
      end
      expect(data.keys).to eq desired_dates
    end

    it "returns array of pages with counts for each date" do
      pages = data.values.sample
      expect(pages.length).to be > 0
      page_data = pages.sample
      expect(page_data[:url]).to be_present
      expect(page_data[:url]).to be_a String
      expect(page_data[:count]).to be > 0
    end
  end

  describe ".top_pages" do
    let(:data) {PageView.top_pages(2.days.ago, Date.today)}

    it_behaves_like "pages report"
  end

  describe ".top_referrers" do
    let(:data) {PageView.top_referrers(2.days.ago, Date.today)}

    it_behaves_like "pages report"

    it "returns no more than 10 pages for each date" do
      expect(data.values.map(&:length).detect {|l| l > 10}).to be_nil
    end

    it "returns no more than 5 top referrers with url and visits count for each page" do
      page_data = data.values.sample
      expect(page_data.map(&:length).detect {|l| l > 5}).to be_nil
      referrers = page_data.sample[:referrers]
      expect(referrers).to be_an Array
      referrer = referrers.sample
      expect(referrer[:url]).to be_present
      expect(referrer[:url]).to be_a String
      expect(referrer[:count]).to be > 0
    end
  end
end
