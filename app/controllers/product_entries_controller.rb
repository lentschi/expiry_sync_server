class ProductEntriesController < ApplicationController
  before_filter :authenticate_user!
  
  def create
    unless product_entry_params[:article].nil?
      Rails.logger.info "--- Current user id: "+current_user.id.to_s + ", initial params"+params[:product_entry].to_yaml.to_s
      
      image_params = Array.new
      image_params = product_entry_params[:article][:images].clone unless product_entry_params[:article][:images].nil?
      image_params = [] if image_params.nil? # s. https://github.com/rails/rails/issues/13766
      params[:product_entry][:article].delete :images
      
      @article = Article.smart_find_or_initialize(product_entry_params[:article])
      article_change_required = (@article.id.nil? or (@article.name != product_entry_params[:article][:name]))
      @article.name = product_entry_params[:article][:name]
      @article.decode_images(image_params)
      @article.source = ArticleSource.get_user_source
      Rails.logger.info "Save: "+@article.save().to_s if article_change_required
      Rails.logger.info "Errors: "+@article.errors.to_yaml.to_s
        
      params[:product_entry].delete :article
      params[:product_entry][:article_id] = @article.id
    end
    
    product_entry_params.delete :article
    Rails.logger.info "--- New product entry: "+product_entry_params.to_yaml.to_s
    
    @product_entry = ProductEntry.new(product_entry_params)
    if @product_entry.save
      respond_to do |format|
        format.html { redirect_to @product_entry }
        format.json do
          product_entry = @product_entry.attributes
          product_entry[:article] = @product_entry.article.attributes
          render json: {status: 'success', product_entry: product_entry}
       end
      end
    else
      respond_to do |format|
        format.html { render "new"}
        format.json { render json: {status: 'failure'}}
      end
    end 
  end
  
  def update
  	# TODO
  end
  
  def destroy
  	if ProductEntry.find(product_entry_params[:product_entry][:id]).destroy
	  	respond_to do |format|
	        format.html { redirect_to @product_entry }
	        format.json do
	          product_entry = @product_entry.attributes
	          product_entry[:article] = @product_entry.article.attributes
	          render json: {status: 'success', product_entry: product_entry}
	        end
	    end
  	else
  		respond_to do |format|
        format.html { render "delete"}
        format.json { render json: {status: 'failure'}}
      end
  	end
  end
  
 	def product_entry_params
 		# s. https://github.com/rails/rails/issues/13766 :
 		unless params[:product_entry].nil? or params[:product_entry][:article].nil? or params[:product_entry][:article][:images].nil?
 			allowed_images = {images: [:image_data, :mime_type, :original_extname]}
 		else
 			allowed_images = :images
 		end
 		
		params.require(:product_entry).permit(
			{article: [:name, :barcode, allowed_images]}, 
			:article_id, # <- added manually, will simply be overwritten, if passed by client
			:location_id, 
			:description, 
			:expiration_date, 
			:amount
		)
	end
end
