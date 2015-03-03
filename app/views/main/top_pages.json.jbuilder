@top_pages.each do |date, pages|
  json.set! date do
    json.array! pages do |page|
      json.url page[:url]
      json.visits page[:count]
    end
  end
end
