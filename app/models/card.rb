# A card has a front side, a back side, and the number of the box it's in. 
# The front side, and back side are obligatory.
# The box number must either 1, 2, or 3.
# All cards belong to a topic.
class Card
  include Mongoid::Document
  field :front, type: String
  field :back, type: String
  field :level, type: Integer, default: 1
  field :review_date, type: Date, default: Date.today

  embbeds_one :card_statistic
  belongs_to :topic
  belongs_to :user

  validates :front, :back, :level, presence: true
  validates :topic, presence: { is: true, message: "must belong to a topic." }
  validates :user, presence: { is: true, message: "must belong to a user." }
  validates :level, numericality: { only_integer: true, greater_than: 0 }

  # Moves a card that was answered correctly to the next level.
  def self.correct(card)
  	card.inc(level: 1)
  end

  # Moves a card that was answered incorrectly to the previous level.
  def self.incorrect(card)
    if card.level > 1
      card.inc(level: -1)
    end
  end

  # Update review date based on level, and desired recall percentage of the topic.
  # Recall function: R = e^(-t/S)
  # where t is the number of days that can pass without studying the card before
  # it recall percentage drops below the topic's.
  # S = 2^n, where n is the card level
  def self.update_review_date(card)
    r = card.topic.recall_percentage
    n = card.level

    # Level of understanding
    s = 2**level

    # t = -ln(R)*S
    t = -s*Math.log(r)

    # Update date
    card.review_date += t
    card.save
  end

  # Moves a card back to box 1.
  def self.reset(card)
  	card.update(level: 1)
  end
end
