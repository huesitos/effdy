# CardStatistic keeps a record of the times a card was answered correctly and
# incorrectly. Also, it saves how much time it takes to answer it each time in
# minutes.
class CardStatistic
  include Mongoid::Document
  field :times_correct, type: Integer, default: 0
  field :times_incorrect, type: Integer, default: 0
  field :time_answering, type: Integer, default: 60 #secs
  field :level, type: Integer, default: 1
  field :review_date, type: DateTime, default: Date.today

  belongs_to :card
  belongs_to :user

  validates :level, :review_date, presence: true
  validates :user, presence: { is: true, message: "must be specified" }
  validates :level, numericality: { only_integer: true, greater_than: 0 }

  def self.from_user(user_id)
    CardStatistic.where(user_id: user_id)
  end

  # Returns the approximate time it takes to answer the card in 
  # minutes
  def approx_time_to_answer
    d = self.times_correct + self.times_incorrect
    if d > 0
      (self.time_answering / d) / 60
    else
      (self.time_answering) / 60
    end
  end

  # Moves a card that was answered correctly to the next level, and updates
  # the time it takes to answer the card.
  def correct(total_time)
    self.inc(level: 1)
    self.inc(time_answering: total_time)
    self.inc(times_correct: 1)
  end

  # Moves a card that was answered incorrectly to the previous level, and updates
  # the time it takes to answer the card.
  def incorrect(total_time)
    if self.level > 1
      self.inc(level: -1)
    end
    self.inc(time_answering: total_time)
    self.inc(times_incorrect: 1)
  end

  # Moves a card back to level 1.
  def reset
    self.update(level: 1)
  end

  # Given a level and a recall percentage, calculate the time span before reviewing again
  # Recall function: R = e^(-t/S)
  # where t is the number of days that can pass without studying the card before
  # it recall percentage drops below the topic's.
  # S = 2^n, where n is the card level
  def calculate_time(r, n)
    # Level of understanding
    s = 2**n

    # t = -ln(R)*S
    t = -s*Math.log(r)
    t
  end

  # Update review date based on level, and desired recall percentage of the topic.
  def update_review_date
    topic_config = self.card.topic.topic_configs.find_by(user_id: self.user.id)

    t = self.calculate_time(topic_config.recall_percentage, self.level)

    # Update date
    self.update(review_date: DateTime.now + t)
  end

  def card_review_projection(review_date, n)
    topic_config = self.card.topic.topic_configs.find_by(user_id: self.user.id)

    t = calculate_time(topic_config.recall_percentage, n)

    review_date + t
  end
end
