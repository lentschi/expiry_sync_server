class LocationSharesController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource :location

  def create
    location = Location.find_by_id(params[:location_id])
    user = User.find_by_username(location_share_params[:username])

    if user.nil?
      respond_to do |format|
        format.html { render action: 'new' }
        format.json { render json: {status: :failure, errors: {username: [
          I18n.t(:no_such_user, login: location_share_params[:username])
        ]}} }
      end
      return
    end

    location.users << user

    respond_to do |format|
      if location.save
        format.html { redirect_to location, notice: 'Location was successfully shared.' }
        format.json { render json: {status: :success, user: user} }
      else
        format.html { render action: 'new' }
        format.json { render json: {status: :failure} }
      end
    end
  end

  private
    def location_share_params
      params.require(:user).permit(:username, :email)
    end
end
