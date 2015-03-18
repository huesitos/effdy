class Card
  include Mongoid::Document
  field :question, type: String
  field :answer, type: String
  field :box, type: Integer
  belongs_to :topic

  validates :question, :answer, :topic, :box, presence: true
  validates :box, inclusion: 1..3

  def self.correct(card)
  	card.update(box: (card.box + 1)) if card.box + 1 <= 3
  end

  def self.reset(card)
  	card.update(box: 1)
  end
end
