class Apartment
  include Mongoid::Document
  include Mongoid::Timestamps
  field :user_id, type: String
  field :name, type: String
  field :street_address, type: String
  field :zip_code, type: Integer
  field :state, type: String
  field :icon_color, type: String
  field :type, type: String
  field :bedrooms, type: Integer
  field :bathrooms, type: Integer
  field :price, type: Integer
  field :status, type: String
end
