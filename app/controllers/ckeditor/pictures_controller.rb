class Ckeditor::PicturesController < Ckeditor::ApplicationController

  def index
    @pictures = Ckeditor::Picture.where(site_id: @site.id).find_all(ckeditor_pictures_scope)
    @pictures = Ckeditor::Paginatable.new(@pictures).page(params[:page])

    respond_with(@pictures, :layout => @pictures.first_page?)
  end

  def create
    @picture = Ckeditor.picture_model.new
    @picture.update_attributes(site_id: @site.id)
    respond_with_asset(@picture)
  end

  def destroy
    @picture.destroy
    respond_with(@picture, :location => pictures_path)
  end

  protected

    def find_asset
      @picture = Ckeditor::Picture.where(site_id: @site.id).get!(params[:id])
    end

    def authorize_resource
      model = (@picture || Ckeditor.picture_model)
      @authorization_adapter.try(:authorize, params[:action], model)
    end
end
