class ReviewConfiguration
  include Mongoid::Document
  field :name, type: String
  field :box1_frequency, type: Integer
  field :box2_frequency, type: Integer
  field :box3_frequency, type: Integer

  validates :name, uniqueness: true, presence: true
end
