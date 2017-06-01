require 'open-uri'
require 'open_uri_redirections'

class ArticleImagesController < ApplicationController
  before_action :set_article_image, only: [:show, :edit, :update, :destroy]

  # GET /article_images
  # GET /article_images.json
  def index
    @article_images = ArticleImage.all
  end

  # GET /article_images/1
  # GET /article_images/1.json
  def show
  end

  def serve
    @image = ArticleImage.find(params[:id])
    raise ActionController::RoutingError.new("No such image") if @image.nil? or (@image.source_url.nil? and @image.image_data.nil?)
    if @image.image_data.nil?
      result = open(@image.source_url, allow_redirections: :all)
      @image.image_data = result.read
      @image.original_extname = File.extname(@image.source_url)
      @image.original_basename = File.basename(@image.source_url, @image.original_extname)
      @image.mime_type = result.content_type
      @image.save
    end

    send_data(@image.image_data, :type => @image.mime_type, :filename => "#{params[:id]}#{@image.original_extname}", :disposition => "inline")
  end

  # GET /article_images/new
  def new
    @article_image = ArticleImage.new
  end

  # GET /article_images/1/edit
  def edit
  end

  # POST /article_images
  # POST /article_images.json
  def create
    @article_image = ArticleImage.new(article_image_params)

    respond_to do |format|
      if @article_image.save
        format.html { redirect_to @article_image, notice: 'Article image was successfully created.' }
        format.json { render action: 'show', status: :created, location: @article_image }
      else
        format.html { render action: 'new' }
        format.json { render json: @article_image.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /article_images/1
  # PATCH/PUT /article_images/1.json
  def update
    respond_to do |format|
      if @article_image.update(article_image_params)
        format.html { redirect_to @article_image, notice: 'Article image was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @article_image.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /article_images/1
  # DELETE /article_images/1.json
  def destroy
    @article_image.destroy
    respond_to do |format|
      format.html { redirect_to article_images_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article_image
      @article_image = ArticleImage.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def article_image_params
      params.require(:article_image).permit(:source_url, :image_data, :article_id, :article_source_id, :creator_id)
    end
end
