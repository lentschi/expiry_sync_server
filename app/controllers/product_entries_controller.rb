class ProductEntriesController < ApplicationController
  before_filter :authenticate_user!
  
  def create
    product_entry_params = params[:product_entry]
    unless params[:product_entry][:article].nil?
      article = Article.find_or_create(product_entry_params[:article])
        
      product_entry_params.delete :article
      product_entry_params[:article_id] = article.id
    end
    @product_entry = ProductEntry.new(product_entry_params)
    if @product_entry.save
      respond_to do |format|
        format.html { redirect_to @product_entry }
        format.json { render json: {status: 'success', product_entry: @product_entry}}
      end
    else
      respond_to do |format|
        format.html { render "new"}
        format.json { render json: {status: 'failure'}}
      end
    end 
  end
end
