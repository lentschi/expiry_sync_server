class ArticlesController < ApplicationController
  before_filter :authenticate_user!
  
  def by_barcode
    article = Article.smart_find_or_initialize(current_user, barcode: params[:barcode])
      
    respond_to do |format|
      format.html
      format.json do
        unless article.nil?
          render json: {status: 'success', article: article}
        else
          render json: {status: 'failure'}
        end
      end
    end
  end
end
