class ApartmentsController < ApplicationController
  before_action :set_apartment, only: [:show, :update, :destroy]

  # GET /apartments
  def index
    @apartments = Apartment.where(:user_id => @authenticated_user["sub"])

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
      render json: @apartment, status: :created, location: @apartment
    else
      render json: @apartment.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /apartments/1
  def update
    if @apartment.update(apartment_params)
      render json: @apartment
    else
      render json: @apartment.errors, status: :unprocessable_entity
    end
  end

  # DELETE /apartments/1
  def destroy
    @apartment.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_apartment

      apartment = Apartment.find(params[:id])

      if apartment[:user_id] != @authenticated_user["sub"]
        render json: "Forbidden", status: 403
        return
      end

      @apartment = apartment
    end

    # Only allow a trusted parameter "white list" through.
    def apartment_params
      params.require(:apartment).permit(:name, :list_id, :street_address, :zip_code, :icon_color, :type, :bedrooms, :bathrooms, :price, :status)
    end
end
