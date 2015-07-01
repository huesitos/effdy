class ShareRequest
  include Mongoid::Document
  field :kind, type: String
  field :object_type, type: String
  field :oid, type: String
  field :recipient, type: String
  field :sender_id, type: String
  field :sender_uname, type: String
  field :name, type: String
  validates :kind, :object_type, :oid, :recipient, :name, :sender_id, :sender_uname, presence: true
end
