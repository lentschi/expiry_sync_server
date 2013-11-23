class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :prepare_params_for_can_can, only: [:create]
  
  # required by the 'clerk'-gem (track creator and modifier user):
  include SentientController
  
  #TODO: Research if that doesn't just make things unsafe:
  protect_from_forgery with: :null_session, :if => Proc.new { |c| c.request.format == 'application/json' }
  skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }
  
  # CanCan:
  rescue_from CanCan::AccessDenied do |exception|
    raise ActionController::RoutingError.new('Forbidden')
  end
  
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
end
