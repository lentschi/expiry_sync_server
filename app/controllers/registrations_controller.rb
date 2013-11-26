require 'debugger'

class RegistrationsController < Devise::RegistrationsController
  
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
    
  # PUT /resource
  # We need to use a copy of the resource because we don't want to change
  # the current user in place.  
  def update
    resource_class.email_is_required = true
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    if update_resource(resource, account_update_params)
      if is_navigational_format?
        flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
          :update_needs_confirmation : :updated
        set_flash_message :notice, flash_key
      end
      sign_in resource_name, resource, :bypass => true
      respond_with resource, :location => after_update_path_for(resource) do |format|
        format.html
        format.json { render json: {status: 'success'} }
      end
    else
      clean_up_passwords resource
      respond_with resource do |format|
        format.html
        format.json { render json: {status: 'error', errors: resource.errors.to_hash}}
      end
    end
  end
end