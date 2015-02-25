# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

topic = Topic.create(title: 'Capital cities')
topic.cards.create([{question: 'Algeria', answer: 'Algiers', box: 1, topic_id: topic._id}, {question: 'Argentina', answer: 'Buenos Aires', box: 1, topic_id: topic._id}, {question: 'Armenia', answer: 'Yerevan', box: 1, topic_id: topic._id}, {question: 'Bolivia', answer: 'La Paz', box: 1, topic_id: topic._id}, {question: 'Brazil', answer: 'Brasilia', box: 1, topic_id: topic._id}, {question: 'Chile', answer: 'Santiago', box: 1, topic_id: topic._id}, {question: 'China', answer: 'Beijing', box: 1, topic_id: topic._id}, {question: 'Colombia', answer: 'Bogota', box: 1, topic_id: topic._id}, {question: 'Dominican Republic', answer: 'Santo Domingo', box: 1, topic_id: topic._id}, {question: 'Egypt', answer: 'Cairo', box: 1, topic_id: topic._id}, {question: 'France', answer: 'Paris', box: 1, topic_id: topic._id}])