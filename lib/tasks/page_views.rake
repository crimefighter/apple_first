namespace :page_views do
  task :populate => :environment do
    PageView.truncate
    PageViewPopulator.populate!
    Rails.cache.clear
  end
end
