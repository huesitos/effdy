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
  field :reviewing, type: Boolean
  belongs_to :topic
  belongs_to :user

  validates :box, presence: true, inclusion: 1..3

  # Returns the review boxes from all unarchived topics set for review that must 
  # be studied today.
  def self.todays_study(user)
    review_boxes = []

    rbs = ReviewBox.where(:review_date.lte => Date.today.to_s, user_id: user._id, reviewing: true)
    rbs.each do |rb|
      if rb.topic.cards.where(box: rb.box).count > 0 # only add if there are cards in the box
        if not rb.topic.archived
          review_boxes.push(rb)
        end
      end
    end

    review_boxes.sort! { |rb1, rb2| rb2.review_date <=> rb1.review_date }
    review_boxes.sort! { |rb1, rb2| rb1.box <=> rb2.box }
  end

  # Returns a hash with the review boxes to study in a week starting from Date.today
  # to Date.today + 6
  def self.weeks_study(user)
    week = {}
    review_boxes = []

    (0..6).each do |day|
      week[(Date.today+day).to_s] = []
    end

    (0..6).each do |day|
      rbs = ReviewBox.where(:review_date => (Date.today+day).to_s, user_id: user._id, reviewing: true)
      rbs.each do |rb|
        if rb.topic.cards.where(box: rb.box).count > 0 # only add if there are cards in the box
          if not rb.topic.archived 
            review_boxes.push(rb)
          end
        end
      end
    end

    (0..6).each do |day|
      review_boxes.each do |rb|
        date = Date.parse(rb.review_date)
        
        if date.to_s == (Date.today+day).to_s
          week[(Date.today+day).to_s].push(rb)

          config = ReviewConfiguration.find_by(name: Topic.find(rb.topic_id).review_configuration)

          # If the review box date has already expired the starting date to calculate the calendar
          while (date + config.box_frequencies[rb.box-1]).to_s <= (Date.today + 6).to_s
            date += config.box_frequencies[rb.box-1]
            week[date.to_s].push(rb)
          end
        end
      end
    end

    review_boxes = []
    # Get expired boxes
    rbs = ReviewBox.where(:review_date.lt => Date.today.to_s, user_id: user._id, reviewing: true)
    rbs.each do |rb|
      if rb.topic.cards.where(box: rb.box).count > 0 # only add if there are cards in the box
        if not rb.topic.archived 
          review_boxes.push(rb)
        end
      end
    end

    review_boxes.each do |rb|
      date = Date.today
      week[date.to_s].push(rb)
      
      config = ReviewConfiguration.find_by(name: Topic.find(rb.topic_id).review_configuration)

      # If the review box date has already expired the starting date to calculate the calendar
      while (date + config.box_frequencies[rb.box-1]).to_s <= (Date.today + 6).to_s
        date += config.box_frequencies[rb.box-1]
        week[date.to_s].push(rb)
      end
    end

    week
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
      review_box.update(review_date: (Date.today + config.box_frequencies[review_box.box-1]).to_s)
    end
  end
end
