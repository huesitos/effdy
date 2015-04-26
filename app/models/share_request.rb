class ShareRequest
  include Mongoid::Document
  field :type, type: String
  field :oid, type: String
  field :recipient, type: String
  field :sender, type: String
  validates :type, :oid, :recipient, :sender, presence: true
end
