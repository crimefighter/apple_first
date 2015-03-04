namespace :page_views do
  task :populate => :environment do
    PageView.truncate
    PageViewPopulator.populate!
  end
end
