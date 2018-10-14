class ProductEntriesController < ApplicationController
  before_action :authenticate_user!
#  load_and_authorize_resource
  load_and_authorize_resource :location, only: [:index_changed]
  load_and_authorize_resource :product_entry, through: :location, only: [:index_changed]
  before_action :set_product_entry, only: [:destroy]
  authorize_resource only: [:destroy]

  def create
    unless product_entry_params[:article].nil?
      Rails.logger.info "--- Current user id: "+current_user.id.to_s + ", initial params"+params[:product_entry].to_yaml.to_s

      image_params = Array.new
      image_params = product_entry_params[:article][:images].clone unless product_entry_params[:article][:images].nil?
      image_params = [] if image_params.nil? # s. https://github.com/rails/rails/issues/13766
      params[:product_entry][:article].delete :images

      @article = Article.smart_find_or_initialize(product_entry_params[:article])
      article_change_required = (@article.id.nil? or (@article.name != product_entry_params[:article][:name]))
      @article.name = product_entry_params[:article][:name]
      @article.decode_images(image_params)
      @article.source = ArticleSource.get_user_source
      Rails.logger.info "Save: "+@article.save().to_s if article_change_required
      Rails.logger.info "Errors: "+@article.errors.to_yaml.to_s

      params[:product_entry].delete :article
      params[:product_entry][:article_id] = @article.id
    end

    Rails.logger.info "--- New product entry: "+product_entry_params.to_yaml.to_s

    @product_entry = ProductEntry.new(product_entry_params)
    if @product_entry.save
      respond_to do |format|
        format.html { redirect_to @product_entry }
        format.json do
          product_entry = @product_entry.attributes
          product_entry[:article] = @product_entry.article.attributes
          render json: {status: 'success', product_entry: product_entry}
        end
      end
    else
      respond_to do |format|
        format.html { render "new"}
        format.json { render json: {status: 'failure', errors: @product_entry.errors}}
      end
    end
  end

  def update
  	@product_entry = ProductEntry.with_deleted.find_by(id: params[:id])
  	raise ActiveRecord::RecordNotFound if @product_entry.nil? # TODO: Find out if this is really necessary

  	unless product_entry_params[:article].nil?
  		if @product_entry.article.barcode != product_entry_params[:article][:barcode]
  			@article = Article.smart_find_or_initialize(product_entry_params[:article])
  		else
  			@article = @product_entry.article
  		end
  		article_change_required = (@article.id.nil? or (@article.name != product_entry_params[:article][:name]))
  		@article.name = product_entry_params[:article][:name]
  		@article.source = ArticleSource.get_user_source if @article.source.nil?
  		Rails.logger.info "Save: "+@article.save().to_s if article_change_required
      Rails.logger.info "Errors: "+@article.errors.to_yaml.to_s

  		params[:product_entry].delete :article
      params[:product_entry][:article_id] = @article.id
  	end

  	respond_to do |format|
      if @product_entry.update(product_entry_params.merge({deleted_at: nil}))
        format.html { redirect_to @product_entry, notice: 'Product entry was successfully updated.' }
        format.json do
          product_entry = @product_entry.attributes
          product_entry[:article] = @product_entry.article.attributes
          render json: {status: 'success', product_entry: product_entry}
        end
      else
        format.html { render action: 'edit' }
        format.json { render json: {status: :failure} }
      end
    end
  end

  def destroy
    @product_entry.destroy unless @product_entry.nil?

    respond_to do |format|
      format.html { redirect_to product_entries_url }
      format.json { render json: {status: :success} }
    end
  end

  def index_changed
    location = Location.find_by_id(params[:location_id])
    @product_entries = location.product_entries
    @deleted_product_entries = location.product_entries.with_deleted.where.not('deleted_at IS NULL')

    unless product_entry_index_params[:from_timestamp].nil?
      from_timestamp = DateTime.strptime(product_entry_index_params[:from_timestamp], '%a, %d %b %Y %H:%M:%S %z').in_time_zone
      @product_entries = @product_entries.where('updated_at >= :from_timestamp', {from_timestamp: from_timestamp})
      @deleted_product_entries = @deleted_product_entries.where('deleted_at >= :from_timestamp', {from_timestamp: from_timestamp})
    end

    respond_to do |format|
      format.json do
        render json: {
          status: 'success',
          product_entries: JSON.parse(@product_entries.to_json(include: {
            article: {include: {images: {except: :image_data}}},
            creator: {}
          })),
          deleted_product_entries: JSON.parse(@deleted_product_entries.to_json(include: :article)),
        }
      end
    end
  end

  private
   	def product_entry_params
   		# s. https://github.com/rails/rails/issues/13766 :
   		unless params[:product_entry].nil? or params[:product_entry][:article].nil? or params[:product_entry][:article][:images].nil?
   			allowed_images = {images: [:image_data, :mime_type, :original_extname]}
   		else
   			allowed_images = :images
   		end

      allowed_entry_fields = [
        {article: [:name, :barcode, allowed_images]},
        :article_id, # <- added manually, will simply be overwritten, if passed by client
        :location_id,
        :description,
        :expiration_date,
        :amount
      ]

      # only creators may assign free_to_take (This should probably be moved to cancan though)
      if self.action_name=='create' or (@product_entry and (@product_entry.creator.nil? or @product_entry.creator.id == current_user.id))
        allowed_entry_fields << :free_to_take
      end

  		params.require(:product_entry).permit(allowed_entry_fields)
  	end

  	def product_entry_index_params
      params.permit(:from_timestamp)
    end

    def set_product_entry
      @product_entry = ProductEntry.with_deleted.find(params[:id])
    rescue
      # Ignore to stay idempotent
      @product_entry = nil
    end
end
