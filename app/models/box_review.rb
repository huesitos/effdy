class BoxReview
  include Mongoid::Document
  field :box, type: Integer
  field :review_date, type: String
  field :topic_id, type: String
  field :topic_title, type: String

  validates :box, presence: true, inclusion: 1..3
  validates :review_date, presence: true  # regex for date format
  validates :topic_id, presence: true
end
