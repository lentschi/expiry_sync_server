json.array!(@producers) do |producer|
  json.extract! producer, :name, :creator_id, :modifier_id
  json.url producer_url(producer, format: :json)
end
