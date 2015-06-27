class TopicConfig
  include Mongoid::Document
  field :archived, type: Boolean, default: false
  field :reviewing, type: Boolean, default: false
  field :recall_percentage, type: Float, default: 0.8

  belongs_to :topic
  belongs_to :user
end
