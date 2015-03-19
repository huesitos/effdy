# A review configuration contains the review frequencies of each box.
# There are three types: normal, tight, spread.
# It has a unique name, and three frequency numbers, one for each box.
class ReviewConfiguration
  include Mongoid::Document
  field :name, type: String
  field :box1_frequency, type: Integer
  field :box2_frequency, type: Integer
  field :box3_frequency, type: Integer

  validates :name, uniqueness: true
  validates :name, :box1_frequency, :box2_frequency, :box3_frequency, presence: true
end
