# The Review class serves as an aid to keep track of the cards that have been
# reviewed during a study session.
class Review
  include Mongoid::Document
  field :cards, type: Array

  belongs_to :topic
  belongs_to :user

  # Returns a list of topics that have cards that must be studied in the specific date.
  def self.days_study(user, date)
    
  end

  # Returns the next card that hasn't been studied in the current study session
  def self.next_study_card(review)
    
  end

  # Returns the next card that hasn't been studied in the current study session
  def self.next_today_study_card(review)
    
  end
end