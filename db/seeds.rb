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

