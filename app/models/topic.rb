# A topic is used to organize cards. It has a title, a review configuration,
# and three review boxes. Both the title and review configuration must be present.
# It may belong to a subject. It can be set for reviewing, which enables the 
# review boxes to be shown in today study view. If a topic is destroyed, its 
# cards and review boxes are also destroyed. It may belong to a subject. If
# that subject is archived, then the topic is also archived.
class Topic
  include Mongoid::Document
  field :title, type: String
  field :reviewing, type: Boolean
  field :review_configuration, type: String
  field :archived, type: Boolean, default: false
  has_many :cards, dependent: :destroy
  has_many :review_boxes, dependent: :destroy
  belongs_to :subject

  validates :title, length: { minimum: 2 }
  validates :title, :review_configuration, presence: true
  validates_associated :cards

  scope :not_archived, ->{where(archived: false)}

  # Moves all the cards back to box 1.
  def self.reset_cards(topic)
    topic.cards.each do |card|
      Card.reset card
    end
  end

  # Creates three review boxes for the topic.
  def self.set_review_boxes(topic)
    topic.review_boxes.create(box:1)
    topic.review_boxes.create(box:2)
    topic.review_boxes.create(box:3)
  end

  # Sets the review dates of the boxes based on the topic's review configuration.
  def self.set_review_dates(topic)
    config = ReviewConfiguration.find_by(name: topic.review_configuration)

    topic.review_boxes.find_by(box:1).update(review_date: (Date.today +  config.box1_frequency.days).to_s)
    topic.review_boxes.find_by(box:2).update(review_date: (Date.today + config.box2_frequency.days).to_s)
    topic.review_boxes.find_by(box:3).update(review_date: (Date.today + config.box3_frequency.days).to_s)
  end
end
