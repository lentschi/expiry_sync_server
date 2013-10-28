class ArticlesController < ApplicationController
  before_filter :authenticate_user!
  
  def by_barcode
    article = Article.find_or_create { article: {barcode: params[:barcode]} }
      
    respond_to do |format|
      format.html
      format.json do
        if article.nil?
          render json: {status: 'success', article: article}
        else
          render json: {status: 'failure'}
        end
      end
    end
  end
end
