# A card has a question, an answer, and the number of the box it's in. 
# The question, answer, and box fields are obligatory.
# The box number must either 1, 2, or 3.
# All cards belong to a topic.
class Card
  include Mongoid::Document
  field :question, type: String
  field :answer, type: String
  field :box, type: Integer
  belongs_to :topic
  belongs_to :user

  validates :question, :answer, :topic, :box, presence: true
  validates :box, inclusion: 1..3

  # Moves a card that was answered correctly to the next box.
  def self.correct(card)
  	card.update(box: (card.box + 1)) if card.box + 1 <= 3
  end

  # Moves a card back to box 1.
  def self.reset(card)
  	card.update(box: 1)
  end
end
