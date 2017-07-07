class LocationsController < ApplicationController
  before_filter :authenticate_user!

  # This may have become obsolete due to load_and_authorize_resource:
  #before_action :set_location, only: [:show, :edit, :update, :destroy]

  load_and_authorize_resource

  # GET /locations
  # GET /locations.json
  def index
    @locations = Location.all
  end

  def index_mine_changed
    @locations = current_user.locations
    @deleted_locations = current_user.locations.with_deleted.where.not('deleted_at IS NULL')

    unless location_index_params[:from_timestamp].nil?
      from_timestamp = DateTime.strptime(location_index_params[:from_timestamp], '%a, %d %b %Y %H:%M:%S %z').in_time_zone
      @locations = @locations.where('updated_at >= :from_timestamp', {from_timestamp: from_timestamp})
      @deleted_locations = @deleted_locations.where('deleted_at >= :from_timestamp', {from_timestamp: location_index_params[:from_timestamp]})
    end

    respond_to do |format|
      format.json do
        render json: {
          status: 'success',
          locations: JSON.parse(@locations.to_json(include: {
              creator: {},
              users: {}
          })),
          deleted_locations: @deleted_locations
        }
      end
    end
  end

  # GET /locations/1
  # GET /locations/1.json
  def show
  end

  # GET /locations/new
  def new
    @location = Location.new
  end

  # GET /locations/1/edit
  def edit
  end

  # POST /locations
  # POST /locations.json
  def create
    @location = Location.new(location_params)
    @location.users << current_user

    respond_to do |format|
      if @location.save
        format.html { redirect_to @location, notice: 'Location was successfully created.' }
        format.json { render json: {status: :success, location: @location} }
      else
        format.html { render action: 'new' }
        format.json { render json: {status: :failure} }
      end
    end
  end

  # PATCH/PUT /locations/1
  # PATCH/PUT /locations/1.json
  def update
    respond_to do |format|
      if @location.update(location_params)
        format.html { redirect_to @location, notice: 'Location was successfully updated.' }
        format.json { render json: {status: :success, location: @location} }
      else
        format.html { render action: 'edit' }
        format.json { render json: {status: :failure} }
      end
    end
  end

  # DELETE /locations/1
  # DELETE /locations/1.json
  def destroy
    success = @location.destroy

    respond_to do |format|
      format.html { redirect_to locations_url }
      format.json { render json: {status: success ? :success : :failure} }
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def location_params
      params.require(:location).permit(:name)
    end

    def location_index_params
      params.permit(:from_timestamp)
    end
end
