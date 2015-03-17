class Card
  include Mongoid::Document
  field :question, type: String
  field :answer, type: String
  field :box, type: Integer
  belongs_to :topic

  validates :question, :answer, :topic, :box, presence: true
  validates :box, inclusion: 1..3
end
