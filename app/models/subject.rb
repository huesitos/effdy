class Subject
  include Mongoid::Document
  field :code, type: String
  field :title, type: String
  field :color, type: String
  field :archived, type: Mongoid::Boolean
end
