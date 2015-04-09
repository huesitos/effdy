class User
  include Mongoid::Document
  field :username, type: String
  field :name, type: String
  field :image, type: String
  field :provider, type: String
  field :uid, type: String

  has_many :topics
  has_many :subjects

  validates :username, :provider, :uid, presence: true

  def self.find_or_create_from_auth_hash(hash)
    if @user = find_by_provider_and_uid(hash['provider'], hash['uid'])
      @user
    else
      @user = create(username: hash['info']['nickname'], name: hash['info']['name'],image: hash['info']['image'], provider: hash['provider'], uid: hash['uid'])
    end
  end


end
