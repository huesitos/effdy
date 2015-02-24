class Card
  include Mongoid::Document
  field :question, type: String
  field :answer, type: String
  field :box, type: Integer
end
