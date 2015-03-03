Rails.application.routes.draw do
  root to: 'main#index'

  get '/top_pages', to: 'main#top_pages'
  get '/top_referrers', to: 'main#top_referrers'
end
