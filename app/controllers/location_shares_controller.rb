class LocationSharesController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource :location

  def create
    location = Location.find_by_id(params[:location_id])
    # begin
      user = get_user_for_sharing(location_share_params)
    # rescue InvalidEmailError
    #   respond_to do |format|
    #     format.html { render action: 'new' }
    #     format.json { render json: {status: :failure, errors: {email: [I18n.t(:invalid_email_address)]} }}
    #   end
    #   return
    # end

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
    location.updated_at = Time.now

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

  def destroy
    user = User.find(params[:id])
    if cannot? :destroy_share, @location, user
      respond_to do |format|
        format.html {render file: File.join(Rails.root, 'public/403.html'), status: 403, layout: false}
        format.json { render status: 403, json: {status: :failure, errors: [I18n.t('may_not_remove_location_share', days: Rails.configuration.locations[:allow_removing_share_after_inactivity_days])]} }
      end
      return
    end

    removedUsers_arr = @location.users.delete(user)

    respond_to do |format|
      if removedUsers_arr.length == 1
        format.html { redirect_to @location, notice: 'Location was successfully unshared.' }
        format.json { render json: {status: :success, user: removedUsers_arr.first} }
      else
        format.html { redirect_to @location, notice: 'Could not unshare location.' }
        format.json { render json: {status: :failure} }
      end
    end
  end

  private
    def get_user_for_sharing(user_params)
      return share_for_email(user_params[:email]) unless user_params[:email].nil?
      return User.find_by_username(user_params[:username]) unless user_params[:username].nil?
      nil
    end

    def share_for_email(email_address)
      user = User.find_or_initialize_by_email(email_address)
      return user unless user.new_record?

      user.username = user.email
      user.creating_to_accept_share = true
      user.save
      user.send_reset_password_instructions
      user
    end

    def location_share_params
      params.require(:user).permit(:username, :email)
    end
end
