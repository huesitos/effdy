# A topic is used to organize cards. It has a title, a review configuration,
# and three review boxes. Both the title and review configuration must be present.
# It may belong to a subject. It can be set for reviewing, which enables the
# review boxes to be shown in today study view. If a topic is destroyed, its
# cards and review boxes are also destroyed. It may belong to a subject. If
# that subject is archived, then the topic is also archived.
class Topic
  include Mongoid::Document
  field :title, type: String
  field :reviewing, type: Boolean, default: false
  field :review_configuration, type: String, default: 'normal'
  field :archived, type: Boolean, default: false
  has_many :cards, dependent: :destroy
  has_many :review_boxes, dependent: :destroy
  belongs_to :subject
  belongs_to :user

  validates :title, length: { minimum: 2 }
  validates :title, :review_configuration, presence: true
  validates_associated :cards

  scope :not_archived, ->{where(archived: false)}
  scope :reviewing, ->{where(reviewing: true)}

  # Finds all the topics that belong to a user based on the username
  def self.from_user(username)
    user = User.find_by(username: username)
    user ? Topic.where(user_id: user._id) : nil
  end

  # Moves all the cards back to box 1.
  def self.reset_cards(topic)
    topic.cards.each do |card|
      Card.reset card
    end
  end

  # Creates three review boxes for the topic.
  def self.set_review_boxes(topic)
    topic.review_boxes.create(box:1, user_id: topic.user_id, review_date: "")
    topic.review_boxes.create(box:2, user_id: topic.user_id, review_date: "")
    topic.review_boxes.create(box:3, user_id: topic.user_id, review_date: "")
  end

  # Set topic and its review boxes as reviewing
  def self.set_reviewing(topic)
    topic.update(reviewing: true)
    topic.review_boxes.each do |rb|
      rb.update(reviewing: true)
    end
  end

  # Unset topic and its review boxes as reviewing
  def self.unset_reviewing(topic)
    topic.update(reviewing: false)
    topic.review_boxes.each do |rb|
      rb.update(reviewing: false)
    end
  end

  # Sets the review dates of the boxes based on the topic's review configuration.
  def self.set_review_dates(topic)
    config = ReviewConfiguration.find_by(name: topic.review_configuration)

    topic.review_boxes.find_by(box:1).update(review_date: Date.today)
    topic.review_boxes.find_by(box:2).update(review_date: (Date.today + config.box_frequencies[1]).to_s)
    topic.review_boxes.find_by(box:3).update(review_date: (Date.today + config.box_frequencies[2]).to_s)
  end

  # Shares the topic that belongs to another user, with the current user
# It creates a new copy of the topic that belongs to the current user
def self.share(topic, username)
  user = User.find_by(username: username)

  # makes a copy of the topic for the current user
  new_topic = user.topics.create(title: topic.title,
    reviewing: false,
    review_configuration: topic.review_configuration,
    archived: false,
    subject: topic.subject_id)

  Topic.set_review_boxes new_topic

  # copies all the cards in topic to the new topic
  topic.cards.each do |card|
    new_topic.cards.create(question: card.question,
      answer: card.answer,
      box: card.box,
      user_id: user._id)
  end
end
end
