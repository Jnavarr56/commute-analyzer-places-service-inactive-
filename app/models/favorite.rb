class Favorite
  include Mongoid::Document
  include Mongoid::Timestamps
  field :user_id, type: String
  field :name, type: String
  field :category, type: String
  field :street_address, type: String
  field :zip_code, type: String
  field :state, type: String
  field :icon_color, type: String
end
