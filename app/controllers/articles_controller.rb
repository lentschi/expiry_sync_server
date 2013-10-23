class ArticlesController < ApplicationController
  #before_filter :authenticate_user!
  
  def show
    render json: {status: 'success', article: {name: 'Test', description: 'DescTest'}}
  end
end