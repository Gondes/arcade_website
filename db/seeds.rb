# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create( :first_name => 'Admin', :last_name => 'Admin', :user_name => 'Admin',
             :email => 'unsepyon@yahoo.com', :password => 'password', :admin => true, :master_admin => true,
             :forum_access => true, :user_stat_access => true, :user_profile_access => true,
             :game_access => true, :give_access => true)

rank_list = [
  [ 1, 0, "Dirt" ],
  [ 2, 100, "Rock" ],
  [ 3, 300, "Iron" ],
  [ 4, 600, "Bronze" ],
  [ 5, 1000, "Silver" ],
  [ 6, 1500, "Gold" ],
  [ 7, 2100, "Platinum" ],
  [ 8, 2800, "Ruby" ],
  [ 9, 3600, "Emerald" ],
  [ 10, 4500, "Diamond" ]
]

rank_list.each do |level, exp_required, name|
  Rank.create( level: level, exp_required: exp_required, name: name )
end

forum_list = [
  [ "General Discussion", "Just any rambling goes here.", false ],
  [ "Announcements", "Upcoming patches and events.", true ],
  [ "Server Issues", "Report any issues or bugs here.", true ],
  [ "Strategies", "Discuss your strategies and and analysis here.", false ]
]

forum_list.each do |title, description|
  GeneralForumTopic.create( title: title, description: description)
end

faq_list = [
  ["How do I play a game?", "To start off, you must have log into your account or create one if you haven't. Then select a user from the user list to challenge. After creating the game, you must wait for the user to accept."],
  ["Why do I need to pay coins to play?", "You must pay coins to challenge someone of a higher level than yourself (10 coins per level), to prevent lower levels from spamming higher levels."],
  ["How do I create a topic on the forum?", "You must be logged in in order to create a topic or comment on a topic. Go into either General Discussion or Strategies and click New Topic."],
  ["How do I get coins and exp?", "You gain coins and exp by winning games against others"]
]

faq_list.each do |question, answer|
  Faq.create( question: question, answer: answer)
end
