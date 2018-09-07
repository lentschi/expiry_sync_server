class ArticlesController < ApplicationController
  before_action :authenticate_user!, except: [:by_barcode]
      
  def by_barcode
    article = Article.smart_find(barcode: params[:barcode])
    article.save unless article.nil? or not article.id.nil?
    
    respond_to do |format|
      format.html
      format.json do
        unless article.nil?
        json_data = {status: 'success', article: JSON.parse(article.to_json(include: {images: {except: :image_data}}))}
          render json: json_data
        else
          render json: {status: 'failure'}
        end
      end
    end
  end
end
