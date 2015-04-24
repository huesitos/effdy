# A review box is used to keep track of the review dates of each box of a topic.
# Each topic will have three review boxes.
# It has the number of the box it represents, and the review date.
# Also, every time before reviewing it saves the card_id of each card in the box
# inside a cards array to keep track of the ones already studied during the review.
class ReviewBox
  include Mongoid::Document
  field :box, type: Integer
  field :review_date, type: String
  field :cards, type: Array
  belongs_to :topic

  validates :box, presence: true, inclusion: 1..3

  # Returns the review boxes from all unarchived topics set for review that must 
  # be studied today.
  def self.today_study(user)
    topics = Topic.not_archived.where(reviewing: true, user_id: user._id)
    review_boxes = []

    # get topics
    topics.each do |topic|
      topic.review_boxes.where(:review_date.lte => Date.today.to_s).each do |review_box|
        review_boxes.push(review_box) if topic.cards.where(box: review_box.box).count() > 0 # only add if there are cards in the box
      end
    end

    review_boxes.sort! { |rb1, rb2| rb2.review_date <=> rb1.review_date }
    review_boxes.sort! { |rb1, rb2| rb1.box <=> rb2.box }
  end

  # Grabs all the card_ids of the cards inside the box, shuffles them, and pushes 
  # them in the cards array.
  def self.set_cards(review_box, box)
  	review_box.cards = []

    cards = Topic.find(review_box.topic_id).cards.where(box: box)
    cards.each do |card|
      review_box.cards.push(card._id)
    end
    review_box.cards.shuffle!
    review_box.save
  end

  # Changes the date of the box being reviewed if the review_date had passed or 
  # is today using the topic's review configuration.
  def self.update_date(review_box)
  	config = ReviewConfiguration.find_by(name: Topic.find(review_box.topic_id).review_configuration)

    if review_box.review_date <= Date.today.to_s
      if review_box.box == 1
        review_box.update(review_date: (Date.today + config.box1_frequency.day).to_s)
      elsif review_box.box == 2
        review_box.update(review_date: (Date.today + config.box2_frequency.days).to_s)
      else
        review_box.update(review_date: (Date.today + config.box3_frequency.days).to_s )
      end
    end
  end
end
