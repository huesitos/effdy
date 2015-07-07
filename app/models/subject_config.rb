class SubjectConfig
  include Mongoid::Document
  field :archived, type: Boolean, default: false
  field :color, type: String

  belongs_to :subject
  belongs_to :user

  validates :color, presence: true
  validates :color, format: { with: /\A#([A-Fa-f0-9]{3}|[A-Fa-f0-9]{6})\z/, message: "only hex numbers" }

  scope :not_archived, ->{where(archived: false)}

  # Finds all the subject_configs that belong to a user based on the user_id
  def self.from_user(user_id)
    SubjectConfig.where(user_id: user_id)
  end

  # Finds all the subjects that belong to a user based on the user_id
  def self.subjects_from_user(user_id)
    subject_ids = SubjectConfig.not_archived.where(user_id: user_id).pluck(:topic_id)

    Subject.where(:_id => { "$in" => subject_ids })
  end

  # Archives a subject and all its topics.
  def archive(user_id)
    self.update(archived: true)
    self.subject.topics.each do |topic|
      topic.topic_configs.find_by(user_id: user_id).archive user_id
    end
  end

  # Unarchives a subject and all its topics.
  def unarchive(user_id)
    self.update(archived: false)
    self.subject.topics.each do |topic|
      topic.topic_configs.find_by(user_id: user_id).unarchive user_id
    end
  end
end
