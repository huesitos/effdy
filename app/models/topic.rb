class Topic
  include Mongoid::Document
  field :title, type: String
  has_many :cards, dependent: :destroy

  validates :title, presence: true, length: { minimum: 2 }
  validates_associated :cards

  # before destroy, delete cards
end
