class Feedback
  include Mongoid::Document
  field :content, type: String
  field :user, type: String

  validates :content, :user, presence: true
end
