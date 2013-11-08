class ProductEntriesController < ApplicationController
  before_filter :authenticate_user!
  
  def create
    unless params[:product_entry][:article].nil?
      Rails.logger.info "--- Current user id: "+current_user.id.to_s + ", initial params"+params[:product_entry].to_yaml.to_s
      image_params = params[:product_entry][:article][:images].clone
      params[:product_entry][:article].delete :images
      @article = Article.smart_find_or_initialize(wrapped_article_params(params[:product_entry]))
      @article.decode_images(image_params)
      @article.source = ArticleSource.get_user_source
      Rails.logger.info "Save: "+@article.save().to_s if @article.id.nil?
      Rails.logger.info "Errors: "+@article.errors.to_yaml.to_s
        
      params[:product_entry].delete :article
      params[:product_entry][:article_id] = @article.id
    end
    
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
  
  def product_entry_params
    params.require(:product_entry).permit(:article_id, :location_id, :description, :expiration_date, :amount)
  end
  
  def wrapped_article_params(article_params)
    article_params.require(:article).permit(:name, :barcode)
  end
end
