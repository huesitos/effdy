class TopicConfig
  include Mongoid::Document
  field :archived, type: Boolean, default: false
  field :reviewing, type: Boolean, default: false
  field :recall_percentage, type: Float, default: 0.8

  belongs_to :topic
  belongs_to :user

  validates :recall_percentage, numericality: { greater_than: 0, less_than_or_equal_to: 1 }
  scope :not_archived, ->{where(archived: false)}
  scope :reviewing, ->{where(reviewing: true)}

  # Finds all the topic_configs that belong to a user based on the user_id
  def self.from_user(user_id)
    TopicConfig.where(user_id: user_id)
  end

  # Finds all the topics that belong to a user based on the user_id
  def self.topics_from_user(user_id)
    topic_ids = TopicConfig.not_archived.where(user_id: user_id).pluck(:topic_id)

    Topic.where(:_id => { "$in" => topic_ids })
  end
end
