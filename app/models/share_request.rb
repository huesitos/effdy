class ShareRequest
  include Mongoid::Document
  field :type, type: String
  field :oid, type: String
  field :recipient, type: String
  field :sender, type: String
  field :name, type: String
  validates :type, :oid, :recipient, :name, :sender, presence: true
end
