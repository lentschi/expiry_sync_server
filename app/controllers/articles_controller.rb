class ArticlesController < ApplicationController
  before_action :authenticate_user!, except: [:by_barcode]

  def by_barcode
    article = Article.smart_find(barcode: params[:barcode])

    ret = true
    if not article.nil? and article.new_record?
      article.images.each do |image|
        ret = ret && image.save
      end
    end

    ret = ret && article.save unless article.nil? or not article.id.nil?

    respond_to do |format|
      format.html
      format.json do
        if ret
          json_data = {status: 'success', article: JSON.parse(article.to_json(include: {images: {except: :image_data}}))}
          render json: json_data
        else
          render json: {status: 'failure'}
        end
      end
    end
  end
end
