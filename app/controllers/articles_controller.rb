class ArticlesController < ApplicationController
  #before_filter :authenticate_user!
  
  def show
    render json: {status: 'success', article: {name: 'Test', description: params[:barcode], barcode: params[:barcode]}}
  end
  
  def test
  end
end