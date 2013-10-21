class SessionsController < Devise::SessionsController 
  def new
    super
  end

  def create
    self.resource = warden.authenticate!(auth_options)
    set_flash_message(:notice, :signed_in) if is_navigational_format?
    sign_in(resource_name, self.resource)
    Rails.logger.debug "HALLO:" + self.resource.to_yaml.to_s
    respond_with self.resource, location: after_sign_in_path_for(resource) do |format|
      format.html
      format.json { render json: self.resource }
    end
  end

end