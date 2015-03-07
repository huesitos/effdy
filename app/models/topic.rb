class Topic
  include Mongoid::Document
  field :title, type: String
  field :reviewing, type: Boolean
  has_many :cards, dependent: :destroy
  has_many :box_reviews, dependent: :destroy
  belongs_to :subject

  validates :title, presence: true, length: { minimum: 2 }
  validates_associated :cards
end
