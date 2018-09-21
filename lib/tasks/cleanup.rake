namespace :cleanup do
  desc "Perform cleanup"
  task :perform, [:date] => [:environment] do |task, args|
    locations_to_remove_arr = []
    users_to_deactivate_arr = []
    Location.all.each do |location|
      recent_access_user = location.users.where("last_sign_in_at > ?", Date.parse(args[:date])).first
      if recent_access_user.nil?
        locations_to_remove_arr << location
        location.users.each do |assigned_user|
          users_to_deactivate_arr << assigned_user unless users_to_deactivate_arr.include?(assigned_user)
        end
      end
    end

    users_to_deactivate_arr.each do |user|
      user.delete
    end

    locations_to_remove_arr.each do |location|
      location.product_entries.each do |entry|
        entry.really_destroy!
      end
      location.really_destroy!
    end

    articles_to_remove_arr = []
    articles_with_serial_to_remove_arr = []
    Article.all.each do |article|
      if ProductEntry.find_by_article_id(article.id).nil?
        articles_to_remove_arr << article
        articles_with_serial_to_remove_arr << article if article.barcode.nil? or article.barcode.strip == ''
      end
    end

    articles_to_remove_arr.each do |article|
      Rails.logger.info "Deleting article #{article.name} #{article.id}"
      article.images.each do |img|
        img.delete
      end
      article.delete
    end

    ProductEntry.with_deleted.all.each do |soft_deleted_entry|
      soft_deleted_entry.really_destroy! unless soft_deleted_entry.deleted_at.nil?
    end

    users_to_deactivate_arr.each do |user|
      Rails.logger.info "Deactivated #{user.username} (sign in count: #{user.sign_in_count}, last sign in: #{user.last_sign_in_at})"
    end

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

    Rails.logger.info "Deactivated #{users_to_deactivate_arr.length} users. Removed #{locations_to_remove_arr.length} locations and #{articles_to_remove_arr.length} articles (#{articles_with_serial_to_remove_arr.length} thereof without barcode). Removed #{multi_images_removed.length} images because the associated articles had more than one image."
  end

  desc "Perform cleanup"
  task :shrink_images, [] => [:environment] do |task, args|
    images = ArticleImage.where(['image_data IS NOT NULL', 'source_url IS NULL'])
    puts "Scanning #{images.length} images"

    initialSize = 0
    images.each do |image|
      initialSize += image.image_data.length
    end

    i = 0
    resized = 0
    gainedBytes = 0
    images.each do |image|
      puts "#{i}/#{images.length}"
      i += 1

      origLength = image.image_data.length
      image.shrink!
      resized += 1
      gainedBytes += origLength - image.image_data.length
    end

    images = ArticleImage.where(['image_data IS NOT NULL', 'source_url IS NULL'])
    finalSize = 0
    images.each do |image|
      finalSize += image.image_data.length
    end

    puts "Done - Resized #{resized} images. Gained #{gainedBytes} bytes. Difference: Before: #{initialSize} bytes vs After: #{finalSize} bytes"
  end
end
