namespace :image_cleanup do
  desc "Perform image cleanup"
  task :perform, [:date] => [:environment] do |task, args|
    multi_images_removed = []
    Article.all.each do |article|
	firstImage = true
	article.images.each do |image|
		unless firstImage
			image.delete
			multi_images_removed << image
		end
		firstImage = false
	end
    end

    Rails.logger.info "Removed #{multi_images_removed.length} images because the associated articles had more than one image."
  end
end
