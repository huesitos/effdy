json.array!(@cards) do |card|
  json.extract! card, :id, :question, :answer, :box
  json.url card_url(card, format: :json)
end
