# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Topic.all.destroy
Subject.all.destroy
BoxReview.all.destroy
DefaultConfiguration.all.destroy
Card.all.destroy

# Creating default configurations
normal = DefaultConfiguration.create(name: 'normal', box1_frequency: 1, box2_frequency: 3, box3_frequency: 7)
DefaultConfiguration.create(name: 'tight', box1_frequency: 1, box2_frequency: 2, box3_frequency: 4)
DefaultConfiguration.create(name: 'spread', box1_frequency: 3, box2_frequency: 6, box3_frequency: 14)

# Example topics

topic = Topic.create(title: 'Capital cities', reviewing: false, review_configuration: 'normal', archived: false)
topic.cards.create([{question: 'Algeria', answer: 'Algiers', box: 1}, {question: 'Argentina', answer: 'Buenos Aires', box: 1}, {question: 'Armenia', answer: 'Yerevan', box: 1}, {question: 'Bolivia', answer: 'La Paz', box: 1}, {question: 'Brazil', answer: 'Brasilia', box: 1}, {question: 'Chile', answer: 'Santiago', box: 1}, {question: 'China', answer: 'Beijing', box: 1}, {question: 'Colombia', answer: 'Bogota', box: 1}, {question: 'Dominican Republic', answer: 'Santo Domingo', box: 1}, {question: 'Egypt', answer: 'Cairo', box: 1}, {question: 'France', answer: 'Paris', box: 1}])
topic.box_reviews.create(box:1, review_date: Date.today)
topic.box_reviews.create(box:2, review_date: (Date.today + normal.box2_frequency.days).to_s)
topic.box_reviews.create(box:3, review_date: (Date.today + normal.box3_frequency.days).to_s)

ps200 = Subject.create(code: 'PS200', name: "American Government", color: "ff9900", archived: false)

topic1 = ps200.topics.create(title: 'American Political Culture', reviewing: false, review_configuration: 'normal', archived: false)
topic1.cards.create([{question: 'government', answer: 'institutions and procedures through which a territory and its people are ruled. (page 4)', box: 1}, {question: 'politics', answer: 'conflict over the leadership, structure, and policies of governments. (page 4)', box: 1}, {question: 'political efficacy', answer: 'the ability to influence government and politics. (page 8)', box: 1}, {question: 'citizenship', answer: 'informed and active membership in a political community. (page 10)', box: 1}, {question: 'autocracy', answer: 'a form of government in which a single individual—a king, queen, or dictator—rules. (page 13)', box: 1}, {question: 'oligarchy', answer: 'a form of government in which a small group—landowners, military officers, or wealthy merchants—controls most of the governing decisions. (page 13)', box: 1}, {question: 'democracy', answer: 'a system of rule that permits citizens to play a significant part in the governmental process, usually through the election of key public officials. (page 13)', box: 1}, {question: 'constitutional government', answer: 'a system of rule in which formal and effective limits are placed on the powers of the government. (page 13)', box: 1}, {question: 'authoritarian government', answer: 'a system of rule in which the government recognizes no formal limits but may nevertheless be restrained by the power of other social institutions. (page 13)', box: 1}, {question: 'totalitarian government', answer: 'a system of rule in which the government recognizes no formal limits on its power and seeks to absorb or eliminate other social institutions that might challenge it. (page 13)', box: 1}, {question: 'power', answer: 'influence over a government\'s leadership, organization, or policies. (page 15)', box: 1}, {question: 'representative democracy/republic', answer: 'a system of government in which the populace selects representatives, who play a significant role in governmental decision making. (page 15)', box: 1}, {question: 'direct democracy', answer: 'a system of rule that permits citizens to vote directly on laws and policies. (page 15)', box: 1}, {question: 'pluralism', answer: 'the theory that all interests are and should be free to compete for influence in the government; the outcome of this competition is compromise and moderation. (page 16)', box: 1}, {question: 'political culture', answer: 'broadly shared values, beliefs, and attitudes about how the government should function. American political culture emphasizes the values of liberty, equality, and democracy. (page 23)', box: 1}, {question: 'liberty', answer: 'freedom from governmental control. (page 24)', box: 1}, {question: 'limited government', answer: 'a principle of constitutional government; a government whose powers are defined and limited by a constitution. (page 24)', box: 1}, {question: 'laissez-faire capitalism', answer: 'an economic system in which the means of production and distribution are privately owned and operated for profit with minimal or no government interference. (page 24)', box: 1}])
topic1.box_reviews.create(box:1, review_date: Date.today)
topic1.box_reviews.create(box:2, review_date: (Date.today + normal.box2_frequency.days).to_s)
topic1.box_reviews.create(box:3, review_date: (Date.today + normal.box3_frequency.days).to_s)