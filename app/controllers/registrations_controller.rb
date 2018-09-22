class RegistrationsController < Devise::RegistrationsController
  before_action :require_email_on_user, only: [ :update ]
  
  
  def new
    super
  end
  
  def create
    build_resource(sign_up_params)

    if resource.save
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_up(resource_name, resource)
        respond_with resource, :location => after_sign_up_path_for(resource) do |format|
          format.html
          format.json { render json: {status: 'success', user: self.resource} }
        end
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!
        respond_with resource, :location => after_inactive_sign_up_path_for(resource) do |format|
          format.html
          format.json { render json: {status: 'success', user: self.resource} }
        end
      end
    else
      clean_up_passwords resource
      respond_with resource do |format|
        format.html
        format.json { render json: {status: 'error', errors: resource.errors.to_hash}}
      end
    end
  end
  
  def update
    @user = User.find(current_user.id)
    successfully_updated = if account_update_params[:password].present?
      @user.update_with_password(account_update_params)
    else
      # remove the virtual current_password attribute update_without_password
      # doesn't know how to ignore it
#      account_update_params.delete(:current_password)
      @user.update_without_password(account_update_params)
    end
    
    if successfully_updated
      set_flash_message :notice, :updated
      # Sign in the user bypassing validation in case his password changed
      bypass_sign_in @user
      respond_with @user do |format|
        format.html { redirect_to after_update_path_for(@user) }
        format.json { render json: {status: 'success'} }
      end
    else
      clean_up_passwords @user
      respond_with @user do |format|
        format.html { render 'edit' }
        format.json { render json: {status: 'error', errors: resource.errors.to_hash}}
      end
    end
  end
  
  def destroy
    resource.destroy
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    respond_with @user do |format|
      format.html { redirect_to after_sign_out_path_for(resource_name) }
      format.json { render json: {status: 'success', user: self.resource} }
    end
  end
  
  protected
  def require_email_on_user
    User.email_is_required = true
  end
end