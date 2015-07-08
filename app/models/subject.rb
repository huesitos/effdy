# A subject is used to classify topics and organize them.
# It has a unique code, a name, a hex color. All these attributes must be present.
# A subject can be set as archived. An archived subject's topics won't
# be listed for showing or reviewing.
class Subject
  include Mongoid::Document
  field :code, type: String
  field :name, type: String
  
  has_many :topics
  has_many :subject_configs, dependent: :destroy
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

  # Destroys all topics inside the subject
  def destroy_topics
    self.topics.each do |t|
      t.destroy
    end
  end

  # Shares the subject that belongs to another user, with the current user
  # It creates a new copy of the subject that belongs to the current user
  def share(recipient_id)
    user = User.find(recipient_id)

    # makes a copy of the subject for the current user
    subject_config = self.subject_configs.find_by(user_id: self.user.id)

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

  # Adds a new collaborator to the subject and its topics
  def add_collaborator(recipient_id)
    owner_subject_config = self.subject_configs.find_by(user_id: self.user.id)
    self.subject_configs.create(
      user_id: recipient_id, 
      color: owner_subject_config.color)

    self.topics.each do |t|
      t.add_collaborator(recipient_id)
    end
  end

  # Adds a remove collaborator to the subject and its topics
  def remove_collaborator(recipient_id)
    subject_config = self.subject_configs.find_by(user_id: recipient_id)
    subject_config.destroy if subject_config

    self.topics.each do |t|
      t.remove_collaborator(recipient_id)
    end
  end
end
