class Subject
  include Mongoid::Document
  field :code, type: String
  field :name, type: String
  field :color, type: String
  field :archived, type: Boolean, default: false
  has_many :topics

  validates :code, uniqueness: true, length: { maximum: 7 }
  validates :name, :code, :color, presence: true
  validates :color, format: { with: /\A([A-Fa-f0-9]{3}|[A-Fa-f0-9]{6})\z/, message: "only hex numbers" }
  validates_associated :topics

  scope :not_archived, -> { where(archived: false) }

  def self.archive(subject)
    subject.update(archived: true)
    subject.topics.each do |topic|
      topic.update(archived: true)
    end
  end

  def self.unarchive(subject)
    subject.update(archived: false)
    subject.topics.each do |topic|
      topic.update(archived: false)
    end
  end

  def self.destroy(subject)
    subject.topics.each do |topic|
      topic.destroy
    end
    subject.destroy
  end
end
