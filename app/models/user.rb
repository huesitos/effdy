class User
  include Mongoid::Document
  field :username, type: String
  field :name, type: String
  field :image, type: String
  field :provider, type: String
  field :uid, type: String
  field :locale, type: String, default: 'en'

  has_many :topics
  has_many :topic_configs
  has_many :subjects
  has_many :subject_configs
  has_many :card_statistics

  validates :username, :provider, :uid, presence: true

  def self.find_or_create_from_auth_hash(hash)
    if @user = find_by(provider: hash['provider'], uid: hash['uid'])
      @user
    else
      if hash['provider'] == "twitter"
        @user = User.create(username: hash['info']['nickname'], name: hash['info']['name'],image: hash['info']['image'], provider: hash['provider'], uid: hash['uid'])
      else
        username = hash['info']['email'].split('@')[0]
        @user = User.create(username: username, name: hash['info']['name'],image: hash['info']['image'], provider: hash['provider'], uid: hash['uid'])
      end
    end
  end
end
