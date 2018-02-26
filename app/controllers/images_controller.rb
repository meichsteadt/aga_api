class ImagesController < ApplicationController
  def show
    if params[:image]
      @image = (RestClient::Resource.new URI.encode(params[:image]), :content_type => 'image/jpg').get
    else
      @product = Product.find(params[:id])
      @image = (RestClient::Resource.new URI.encode(@product.thumbnail), :content_type => 'image/jpg').get
    end
    File.new('img.jpg', 'w') << @image.to_s.force_encoding("utf-8").gsub("Øu0000", '')
    @image = File.open('img.jpg', 'r').read
    respond_to do |format|
      # format.jpg {render json: @image}
      format.jpg {send_file 'img.jpg', type: 'image/jpeg', disposition: 'inline'}
    end
  end
end
