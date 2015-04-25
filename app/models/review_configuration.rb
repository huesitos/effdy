# A review configuration contains the review frequencies of each box.
# There are three types: normal, tight, spread.
# It has a unique name, and three frequency numbers, one for each box.
class ReviewConfiguration
  include Mongoid::Document
  field :name, type: String
  field :box_frequencies, type: Array

  validates :name, uniqueness: true
  validates :name, :box_frequencies, presence: true
end
