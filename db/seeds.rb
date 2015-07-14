# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Removing all documents from the DB
Topic.all.destroy
TopicConfig.all.destroy
Subject.all.destroy
SubjectConfig.all.destroy
Card.all.destroy
CardStatistic.all.destroy
User.all.destroy

# dmlara = User.create("username" => "dmlaramartin", "name" => "Denisse Lara", "image" => "http://pbs.twimg.com/profile_images/3673739764/87b714e822179d84bfce07c72119b0ef_normal.jpeg", "provider" => "twitter", "uid" => "1060238214")
# black = User.create("username" => "blackangel3455", "name" => "Denisse Margarita Lara Martín", "image" => "https://lh3.googleusercontent.com/-NKL_KxeCkpg/AAAAAAAAAAI/AAAAAAAAChE/Y-daSdzchkw/photo.jpg?sz=50", "provider" => "google_oauth2", "uid" => "113747951519490530865")

# t1 = dmlara.topics.create(title: "Topic 1")
# t1.topic_configs.create(
# 	reviewing: true,
# 	user_id: dmlara.id)

# t2 = dmlara.topics.create(title: "Topic 2")
# t2.topic_configs.create(
# 	archived: false, 
# 	reviewing: true,
# 	user_id: dmlara.id)

# c1 = t1.cards.create(
# 	front: "Front side. Tha question", 
# 	back: "Back side. Tha answer.")
# c1.card_statistics.create(user_id: dmlara.id)

# c2 = t1.cards.create(
# 	front: "Front side. Tha question", 
# 	back: "Back side. Tha answer.")
# c2.card_statistics.create(user_id: dmlara.id)

# c3 = t1.cards.create(
# 	front: "Front side. Tha question", 
# 	back: "Back side. Tha answer.")
# c3.card_statistics.create(user_id: dmlara.id)

# c4 = t1.cards.create(
# 	front: "Front side. Tha question", 
# 	back: "Back side. Tha answer.")
# c4.card_statistics.create(user_id: dmlara.id)

# c5 = t1.cards.create(
# 	front: "Front side. Tha question", 
# 	back: "Back side. Tha answer.")
# c5.card_statistics.create(user_id: dmlara.id)

# c6 = t2.cards.create(
# 	front: "Front side. Tha question", 
# 	back: "Back side. Tha answer.")
# c6.card_statistics.create(user_id: dmlara.id)

# c7 = t2.cards.create(
# 	front: "Front side. Tha question", 
# 	back: "Back side. Tha answer.")
# c7.card_statistics.create(user_id: dmlara.id)

# c8 = t2.cards.create(
# 	front: "Front side. Tha question", 
# 	back: "Back side. Tha answer.")
# c8.card_statistics.create(user_id: dmlara.id)

# c9 = t2.cards.create(
# 	front: "Front side. Tha question", 
# 	back: "Back side. Tha answer.")
# c9.card_statistics.create(user_id: dmlara.id)

# c10 = t2.cards.create(
# 	front: "Front side. Tha question", 
# 	back: "Back side. Tha answer.")
# c10.card_statistics.create(user_id: dmlara.id)

# s1= dmlara.subjects.create(
# 	code: "COM381", 
# 	name: "Computer Graphics")
# s1.subject_configs.create(
# 	archived: false, 
# 	color: "#6b0698",
# 	user_id: dmlara.id)

# ts = s1.topics.create(
# 	title: "Topic in subject",
# 	user_id: dmlara.id)
# ts.topic_configs.create(user_id: dmlara.id)

