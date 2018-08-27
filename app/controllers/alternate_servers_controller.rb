class AlternateServersController < ApplicationController
  before_filter :authenticate_user!, except: [:index]
  load_resource except: [:index, :new]
  authorize_resource except: [:index, :new, :create]

  respond_to :html

  def index
    @alternate_servers = AlternateServer.all
    respond_to do |format|
      format.html { respond_with(@alternate_servers) }
      format.json { render json: {
        status: 'success', 
        alternate_servers: JSON.parse(@alternate_servers.to_json(include: :creator))
      }}
    end
  end

  def new
    @alternate_server = AlternateServer.new
    respond_with(@alternate_server)
  end

  def edit
  end

  def create
    # strip superflous i18n fields from params:
    clean_params = alternate_server_params.dup
    I18n.available_locales.each do |lang|
      next unless clean_params["name_#{lang}"].empty? and clean_params["description_#{lang}"].empty?
      clean_params.delete("name_#{lang}")
      clean_params.delete("description_#{lang}")
    end
    
    @alternate_server = AlternateServer.new(clean_params)
    if @alternate_server.save
      flash[:notice] = I18n.t(:successfully_created_alternate_server)
    end
    
    respond_with(@alternate_server, location: alternate_servers_path)
  end

  def update
    # strip superflous i18n fields from params:
    clean_params = alternate_server_params.dup
    I18n.available_locales.each do |lang|
      next unless clean_params["name_#{lang}"].empty? and clean_params["description_#{lang}"].empty? \
        and @alternate_server.send("name_#{lang}".to_sym).nil? and @alternate_server.send("description_#{lang}".to_sym).nil? 
      clean_params.delete("name_#{lang}")
      clean_params.delete("description_#{lang}")
    end
    
    clean_params['replacement_url'] = nil if clean_params['replacement_url'] == ''
    @alternate_server.update(clean_params)
    respond_with(@alternate_server, location: alternate_servers_path)
  end

  def destroy
    if @alternate_server.destroy
      flash[:notice] = I18n.t(:successfully_deleted_alternate_server)
    else
      flash[:notice] = I18n.t(:error_deleting_alternate_server)
    end
    respond_with(@alternate_server, location: alternate_servers_path)
  end

  private
    def alternate_server_params
      fields_arr = [:url, :replacement_url]
      
      I18n.available_locales.each do |lang|
        fields_arr << "name_#{lang}".to_sym
        fields_arr << "description_#{lang}".to_sym
        fields_arr << "replacement_explanation_#{lang}".to_sym
      end
      
      params.require(:alternate_server).permit(fields_arr)
    end
end
