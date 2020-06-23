class FavoritesController < ApplicationController
  before_action :set_favorite, only: [:show, :update, :destroy]

  # GET /favorites
  def index
    @favorites = Favorite.where(:user_id => @authenticated_user["sub"])

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

    if @favorite.save
      render json: @favorite, status: :created, location: @favorite
    else
      render json: @favorite.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /favorites/1
  def update
    if @favorite.update(favorite_params)
      render json: @favorite
    else
      render json: @favorite.errors, status: :unprocessable_entity
    end
  end

  # DELETE /favorites/1
  def destroy
    @favorite.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_favorite
      favorite = Favorite.find(params[:id])

      if favorite[:user_id] != @authenticated_user["sub"]
        render json: "Forbidden", status: 403
        return
      end

      @favorite = favorite
    end

    # Only allow a trusted parameter "white list" through.
    def favorite_params
      params.require(:favorite).permit(:name, :category, :street_address, :zip_code, :state, :icon_color)
    end
end
