# A topic is used to organize cards. It has a title, and a recall_percentage
# The title must be present. Also, the recall_percentage must be a number between
# 0 and 1, including them. It may belong to a subject. It can be set for reviewing.
# When a topic is set for reviewing, the user receives a notification when any card's
# review date is today. If a topic is destroyed, its cards are also destroyed.
# If the subject it belongs to is archived, then the topic is also archived.
class Topic
  include Mongoid::Document
  field :title, type: String
  field :reviewing, type: Boolean, default: false
  field :archived, type: Boolean, default: false
  field :recall_percentage, type: Float, default: 0.8

  has_many :cards, dependent: :destroy

  belongs_to :subject
  belongs_to :user

  validates :title, presence: true
  validates :recall_percentage, numericality: { greater_than: 0, less_than_or_equal_to: 1 }
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

  # Returns all the topics that have to be reviewed today, with the number of cards
  # they have and the approximate amount of time it will take to study it
  def self.topics_to_study(username, date)
    study_topics = []
    topics = Topic.from_user username

    topics.each do |t|
      cards = t.cards.where(:review_date => {"$lte": date})
      at = 0 # approximate time to answer everything

      if cards.count > 0
        cards.each do |c|
          at += CardStatistic.approx_time_to_answer c.card_statistic
        end
        at /= cards.count

        study_topics.push({
          topic: t,
          cards_count: Integer(t.cards.where(:review_date => {"$lte": DateTime.now}).count),
          approx_time: Integer(at)
        })
      end
    end

    study_topics
  end

  # Shares the topic that belongs to another user, with the current user
  # It creates a new copy of the topic that belongs to the current user
  def self.share(topic, username, subject)
    user = User.find_by(username: username)

    # makes a copy of the topic for the current user
    new_topic = user.topics.create(title: topic.title,
      subject: subject._id)

    Topic.set_review_boxes new_topic

    # copies all the cards in topic to the new topic
    topic.cards.each do |card|
      new_topic.cards.create(front: card.front,
        back: card.back,
        user_id: user._id)
    end
  end
end
