class JsonsController < ApplicationController
  before_filter :authenticate_user!
  
  def sign_in
    @users = User.all
    
    render json: @users    
    
  end
end