class Topic
  include Mongoid::Document
  field :title, type: String
  has_many :cards

  validates :title, presence: true, length: { minimum: 2 }
  validates_associated :cards
end
