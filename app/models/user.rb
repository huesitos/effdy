class User
  include Mongoid::Document
  field :username, type: String
  field :name, type: String
  field :image, type: String
  field :provider, type: String
  field :uid, type: String
  field :locale, type: String, default: 'en'
  field :first_time, type: Boolean, default: true

  has_many :topics
  has_many :topic_configs
  has_many :subjects
  has_many :subject_configs
  has_many :card_statistics

  validates :username, :provider, :uid, presence: true


  def self.from_omniauth(provider, hash, locale)
    user_information = hash.info
    uid = hash.uid
    nickname = NicknameFromOmniauth.call(hash)

    find_or_initialize_by(provider: provider, uid: uid).tap do |user|
      user.username = nickname
      user.name     = user_information.name
      user.image    = user_information.image
      user.provider = provider
      user.uid      = uid
      user.locale   = locale
      user.save!
    end
  end

end

class NicknameFromOmniauth

  def initialize(hash)
    @hash = hash
    @user_info = hash.info
  end

  def call
    UserNickname.from(nickname)
  end

  def self.call(hash)
    new(hash).call
  end

  private

  attr_reader :hash, :user_info

  def nickname
    user_info.nickname || email
  end

  def email
    user_or_generic_email.split('@').first
  end

  def user_or_generic_email
    user_info.email || generic_email
  end

  def generic_email
    "aplus#{SecureRandom.hex(2)}@"
  end

  class UserNickname

    NICKNAME_TEMPLATE = '-%{random_seed}'.freeze

    def initialize(nickname)
      @nickname = nickname
    end

    def self.from(nickname)
      new(nickname).call
    end

    def call
      user_already_exists? ? generated_nicknamed : nickname
    end

    private

    def generated_nicknamed
      nickname + user_random
    end

    def user_already_exists?
      !!User.find_by(username: nickname)
    end

    def user_random
      NICKNAME_TEMPLATE % { random_seed: generate_seed }
    end

    def generate_seed
      SecureRandom.random_number(5)
    end

    attr_reader :nickname

  end

end
