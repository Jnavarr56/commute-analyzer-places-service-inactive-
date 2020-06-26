class FavoritesController < ApplicationController
  before_action :set_favorite, only: [:show, :update, :destroy]

  # GET /favorites
  def index
    cache_key = gen_cache_key_prefix
    @favorites = Rails.cache.fetch(cache_key, expires_in: 5.minutes) do
      Favorite.where(:user_id => @authenticated_user["sub"])
    end

    render json: @favorites
  end

  # GET /favorites/1
  def show
    render json: @favorite
  end

  # POST /favorites
  def create

    @favorite = Favorite.new(favorite_params)
    @favorite[:user_id] = @authenticated_user["sub"]
    @favorite[:state] = "NY"

    if @favorite.save
      cache_key = gen_cache_key_prefix + "/#{@favorite[:id]}"
      Rails.cache.write(cache_key, @favorite, expires_in: 5.minutes)
      Rails.cache.delete(gen_cache_key_prefix)

      render json: @favorite, status: :created, location: @favorite
    else
      render json: @favorite.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /favorites/1
  def update
    if @favorite.update(favorite_params)
      Rails.cache.delete(gen_cache_key_prefix)
      render json: @favorite
    else
      render json: @favorite.errors, status: :unprocessable_entity
    end
  end

  # DELETE /favorites/1
  def destroy
    Rails.cache.delete(gen_cache_key_prefix)
    @favorite.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_favorite

      cache_key = gen_cache_key_prefix + "/#{params[:id]}"

      favorite = Rails.cache.fetch(cache_key, expires_in: 5.minutes) do
        puts "anal testament"
        Favorite.find(params[:id])
      end

      if favorite[:user_id] != @authenticated_user["sub"]
        render json: "Forbidden", status: 403
        return
      end

      @favorite = favorite
    end

    # Only allow a trusted parameter "white list" through.
    def favorite_params
      params.require(:favorite).permit(:name, :category, :street_address, :zip_code, :icon_color)
    end

    # Generate a key prefix to access cached data.
    def gen_cache_key_prefix
      "#{@authenticated_user["sub"]}/favorites"
    end 
end
