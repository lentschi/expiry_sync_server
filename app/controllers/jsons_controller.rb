class JsonsController < ApplicationController
  def sign_in
    @users = User.all
    
    render json: @users    
    
  end
end