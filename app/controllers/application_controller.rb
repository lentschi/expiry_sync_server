class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :prepare_params_for_can_can, only: [:create]
  before_action :configure_permitted_devise_parameters, if: :devise_controller?
  before_action :set_date_response_header
  before_action :set_redirect_url_header, :if => Proc.new { |c| c.request.format == 'application/json' }

  # Log all page impressions with 'impressionist':
  #impressionist :unique => [:controller_name, :action_name, :session_hash], :actions=>[:show, :index]

  # required by the 'clerk'-gem (track creator and modifier user):
  include SentientController

  #TODO: Research if that doesn't just make things unsafe:
  protect_from_forgery with: :null_session, :if => Proc.new { |c| c.request.format == 'application/json' }
  skip_before_action :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }

  # CanCan:
  rescue_from CanCan::AccessDenied do |exception|
    raise ActionController::RoutingError.new('Forbidden')
  end

  # set locale according to HTTP_ACCEPT_LANGUAGE:
  include HttpAcceptLanguage::AutoLocale

  protected
  # workaround to make CanCan and rails 4 work together on create actions
  # s. https://github.com/ryanb/cancan/issues/835#issuecomment-20229737 and
  # http://stackoverflow.com/questions/19273182/activemodelforbiddenattributeserror-cancan-rails-4-model-with-scoped-con/19504322#19504322
  # don't quite get it myself - TODO: Check if this could be a security hazard
  def prepare_params_for_can_can
    resource = controller_path.singularize.gsub('/', '_').to_sym
    method = "#{resource}_params"
    params[resource] &&= send(method) if respond_to?(method, true)
  end

  def configure_permitted_devise_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :email, :password, :password_confirmation, :remember_me])
    devise_parameter_sanitizer.permit(:sign_in, keys: [:username, :email, :password, :remember_me])

    #not quite sure why this is required:
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :email, :password, :password_confirmation])
  end

  def set_date_response_header
    response.header['Date'] = Time.now.httpdate
    response.header['Access-Control-Expose-Headers'] = 'Date'
  end

  def api_version
    return 0 if request.headers['X-Expiry-Sync-Api-Version'].nil?
    request.headers['X-Expiry-Sync-Api-Version'].to_i
  end

  def set_redirect_url_header
    return if self.api_version < 2
    redirect_setting = ApplicationSetting.find_by_setting_key('redirect_url')

    return if redirect_setting.nil?

    response.header['Access-Control-Expose-Headers'] = 'X-Expiry-Sync-Permanent-Redirect'
    response.header['X-Expiry-Sync-Permanent-Redirect'] = redirect_setting.setting_value
    render json: {status: 'Expiry-Sync-Permanent-Redirect'}
  end
end
