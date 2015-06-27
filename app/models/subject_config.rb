class SubjectConfig
  include Mongoid::Document
  field :archived, type: Boolean, default: false
  field :color, type: String

  belongs_to :subject
  belongs_to :user

  validates :color, presence: true
  validates :color, format: { with: /\A#([A-Fa-f0-9]{3}|[A-Fa-f0-9]{6})\z/, message: "only hex numbers" }
end
