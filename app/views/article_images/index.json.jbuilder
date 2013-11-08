json.array!(@article_images) do |article_image|
  json.extract! article_image, :source_url, :image_data, :article_id, :article_source_id, :creator_id
  json.url article_image_url(article_image, format: :json)
end
