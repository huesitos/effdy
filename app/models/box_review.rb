class BoxReview
  include Mongoid::Document
  field :box, type: Integer
  field :review_date, type: String
  field :topic, type: String
end
