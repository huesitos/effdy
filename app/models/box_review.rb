class BoxReview
  include Mongoid::Document
  field :box, type: Integer
  field :review_date, type: String
  field :topic_id, type: String
  field :topic_title, type: String
  field :cards, type: Array

  validates :box, presence: true, inclusion: 1..3
  validates :topic_id, presence: true
end
