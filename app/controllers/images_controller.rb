class ImagesController < ApplicationController
  before_action :set_image, only: [:show, :edit, :update, :destroy, :tag]

  # GET /images
  # GET /images.json
  def index
    @images = if params[:untagged_only]
                Image.joins(%Q{LEFT JOIN taggings ON taggings.taggable_id=images.id AND taggings.taggable_type='Image'}).
                    where('taggings.id IS NULL')
              else
                Image.includes(:tags).all
              end
    @images = @images.paginate(:page => params[:page])
  end

  def overview
    @tag = params[:tag] || 'Ok'
    if params[:show_tagged]
      @images = Image.tagged_with(@tag)
    else
      @images = Image.tagged_with(@tag, :exclude => true).order("RANDOM()").limit(100)
    end
    @tagged_count = Image.tagged_with(@tag).count
  end

  # GET /images/1
  # GET /images/1.json
  def show
  end

  # GET /images/1/edit
  def edit
  end

  # PATCH/PUT /images/1
  # PATCH/PUT /images/1.json
  def update
    respond_to do |format|
      if @image.update(image_params)
        format.html { redirect_to @image, notice: 'Image was successfully updated.' }
        format.json { render :show, status: :ok, location: @image }
      else
        format.html { render :edit }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  def serve
    f = params[:filename]
    path = if f.include? 'sketch'
             SKETCH_FOLDER + f
           else
             IMAGE_FOLDER + f
           end
    send_file( path,
               :disposition => 'inline',
               :type => 'image/png',
               :x_sendfile => true )
  end

  def tag
    tag = params[:tag]
    if @image.tag_list.include?(tag)
      @image.tag_list.remove(tag)
    else
      @image.tag_list << params[:tag]
    end
    @image.save!
    render json: { status: 'success' }
  end

  # DELETE /images/1
  # DELETE /images/1.json
  def destroy
    @image.destroy
    respond_to do |format|
      format.html { redirect_to images_url, notice: 'Image was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_image
      @image = Image.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def image_params
      params.require(:image).permit(tag_list: [])
    end
end
