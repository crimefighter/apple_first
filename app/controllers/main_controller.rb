class MainController < ApplicationController
  def index
  end

  def top_pages
    @top_pages = PageView.top_pages(5.days.ago, Date.today)
  end

  def top_referrers
    @top_referrers = PageView.top_referrers(5.days.ago, Date.today)
  end
end
