class Subject
  include Mongoid::Document
  field :code, type: String
  field :title, type: String
  field :color, type: String
  field :archived, type: Boolean
  has_many :topics

  validates :code, uniqueness: true, presence: true, length: { maximum: 6 }
  validates_associated :topics
end
