class User
  include Mongoid::Document
  field :username, type: String
  field :name, type: String
  field :image, type: String
  field :provider, type: String
  field :uid, type: String
end
