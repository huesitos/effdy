# A subject is used to classify topics and organize them.
# It has a unique code, a name, a hex color. All these attributes must be present.
# A subject can be set as archived. An archived subject's topics won't
# be listed for showing or reviewing.
class Subject
  include Mongoid::Document
  field :code, type: String
  field :name, type: String
  
  has_many :topics
  has_many :subject_configs
  belongs_to :user

  validates :code, length: { maximum: 7 }
  validates :name, :code, presence: true
  validates_associated :topics

  # Finds all subjects from a user that are not archived
  def self.not_archived(user_id)
    subject_ids = SubjectConfig.where(archived: false, user_id: user_id).pluck(:subject_id)
    @subjects = Subject.where(:_id => { "$in" => subject_ids })
  end

  # Finds all the topics that belong to a user based on the user_id
  def self.from_user(user_id)
    Subject.where(user_id: user_id)
  end

  # Archives a subject and all its topics.
  def archive
    self.update(archived: true)
    self.topics.each do |topic|
      topic.update(archived: true)
    end
  end

  # Unarchives a subject and all its topics.
  def unarchive
    self.update(archived: false)
    self.topics.each do |topic|
      topic.update(archived: false)
    end
  end

  # Destroys all topics inside the subject
  def destroy_topics
    self.topics.each do |t|
      t.destroy
    end
  end

  # Shares the subject that belongs to another user, with the current user
  # It creates a new copy of the subject that belongs to the current user
  def share(owner_id, recipient_id)
    user = User.find(recipient_id)

    # makes a copy of the subject for the current user
    subject_config = self.subject_configs.find_by(user_id: owner_id)

    new_subject = user.subjects.create(
      code: self.code,
      name: self.name)

    new_subject.subject_configs.create(
      color: subject_config.color,
      archived: false,
      user_id: user.id)

    # copies all the topics in the subject to the new subject
    self.topics.each do |topic|
      topic.share(user.id, new_subject.id)
    end
  end
end
