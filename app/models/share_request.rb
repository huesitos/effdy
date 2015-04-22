class ShareRequest
  include Mongoid::Document
  field :type, type: String
  field :oid, type: String
  field :recipient, type: String
  field :sender, type: String
  validate :type, :oid, :recipient, :sender, presence: true
end
