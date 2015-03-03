@top_referrers.each do |date, pages|
  json.set! date do
    json.array! pages do |page|
      json.url page[:url]
      json.visits page[:visits]
      json.referrers do
        json.array! page[:referrers] do |referrer|
          json.url referrer[:referrer]
          json.visits referrer[:count]
        end
      end
    end
  end
end
