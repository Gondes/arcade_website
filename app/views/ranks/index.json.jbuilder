json.array!(@ranks) do |rank|
  json.extract! rank, :id, :level, :name, :exp_required
  json.url faq_url(rank, format: :json)
end