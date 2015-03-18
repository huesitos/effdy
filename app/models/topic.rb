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

  def self.reset_cards(topic)
    topic.cards.each do |card|
      card.update(box: 1)
    end
  end

  def self.set_review_boxes(topic)
    topic.review_boxes.create(box:1)
    topic.review_boxes.create(box:2)
    topic.review_boxes.create(box:3)
  end

  def self.set_review_dates(topic)
    config = ReviewConfiguration.find_by(name: topic.review_configuration)

    topic.review_boxes.find_by(box:1).update(review_date: (Date.today +  config.box1_frequency.days).to_s)
    topic.review_boxes.find_by(box:2).update(review_date: (Date.today + config.box2_frequency.days).to_s)
    topic.review_boxes.find_by(box:3).update(review_date: (Date.today + config.box3_frequency.days).to_s)
  end
end
