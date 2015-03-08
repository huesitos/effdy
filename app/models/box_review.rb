class BoxReview
  include Mongoid::Document
  field :box, type: Integer
  field :review_date, type: String
  field :cards, type: Array
  belongs_to :topic

  validates :box, presence: true, inclusion: 1..3
end
