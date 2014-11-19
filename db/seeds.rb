# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create( :first_name => 'Admin', :last_name => 'Admin', :user_name => 'Admin',
             :email => 'unsepyon@yahoo.com', :password => 'password', :admin => true)

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
