# A card has a front side, a back side, and the number of the box it's in. 
# The front side, and back side are obligatory.
# The box number must either 1, 2, or 3.
# All cards belong to a topic.
class Card
  include Mongoid::Document
  field :question, type: String
  field :answer, type: String
  
  field :front, type: String
  field :back, type: String

  has_many :card_statistics, dependent: :destroy
  belongs_to :topic

  validates :front, :back, presence: true
  validates :topic, presence: { is: true, message: "must belong to a topic." }
end
