json.array!(@locations) do |location|
  json.extract! location, :uuid, :name, :creator_id, :modifier_id
  json.url location_url(location, format: :json)
end
