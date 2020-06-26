class ApartmentsController < ApplicationController
  before_action :set_apartment, only: [:show, :update, :destroy]

  # GET /apartments
  def index
    cache_key = gen_cache_key_prefix + "/#{params[:id]}"
    @apartments = Rails.cache.fetch(cache_key, expires_in: 5.minutes) do
      Apartment.where(:user_id => @authenticated_user["sub"])
    end

    render json: @apartments
  end

  # GET /apartments/1
  def show
    render json: @apartment
  end

  # POST /apartments
  def create
    @apartment = Apartment.new(apartment_params)
    @apartment[:user_id] = @authenticated_user["sub"]
    @apartment[:state] = "NY"

    if @apartment.save
      cache_key = gen_cache_key_prefix + "/#{@apartment[:id]}"
      Rails.cache.write(cache_key, @apartment, expires_in: 5.minutes)
      Rails.cache.delete(gen_cache_key_prefix)
      
      render json: @apartment, status: :created, location: @apartment
    else
      render json: @apartment.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /apartments/1
  def update
    if @apartment.update(apartment_params)
      Rails.cache.delete(gen_cache_key_prefix)
      render json: @apartment
    else
      render json: @apartment.errors, status: :unprocessable_entity
    end
  end

  # DELETE /apartments/1
  def destroy
    Rails.cache.delete(gen_cache_key_prefix)
    @apartment.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_apartment

      cache_key = gen_cache_key_prefix + "/#{params[:id]}"
      
      apartment = Rails.cache.fetch(cache_key, expires_in: 5.minutes) do
        Apartment.find(params[:id])
      end

      if apartment[:user_id] != @authenticated_user["sub"]
        render json: "Forbidden", status: 403
        return
      end

      @apartment = apartment
    end

    # Only allow a trusted parameter "white list" through.
    def apartment_params
      params.require(:apartment).permit(:name, :street_address, :zip_code, :icon_color, :type, :bedrooms, :bathrooms, :price, :status)
    end

    # Generate a key prefix to access cached data.
    def gen_cache_key_prefix
      "#{@authenticated_user["sub"]}/apartments"
    end 
end
