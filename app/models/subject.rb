# A subject is used to classify topics and organize them.
# It has a unique code, a name, a hex color. All these attributes must be present.
# A subject can be set as archived. An archived subject's topics won't
# be listed for showing or reviewing.
class Subject
  include Mongoid::Document
  field :code, type: String
  field :name, type: String
  field :color, type: String
  field :archived, type: Boolean, default: false
  has_many :topics, dependent: :destroy
  belongs_to :user

  validates :code, uniqueness: true, length: { maximum: 7 }
  validates :name, :code, :color, presence: true
  validates :color, format: { with: /\A([A-Fa-f0-9]{3}|[A-Fa-f0-9]{6})\z/, message: "only hex numbers" }
  validates_associated :topics

  scope :not_archived, -> { where(archived: false) }

  # Finds all the topics that belong to a user based on the username
  def self.from_user(username)
    user = User.find_by(username: username)
    Subject.where(user_id: user._id)
  end
  
  # Archives a subject and all its topics.
  def self.archive(subject)
    subject.update(archived: true)
    subject.topics.each do |topic|
      topic.update(archived: true)
    end
  end

  # Unarchives a subject and all its topics.
  def self.unarchive(subject)
    subject.update(archived: false)
    subject.topics.each do |topic|
      topic.update(archived: false)
    end
  end
end
