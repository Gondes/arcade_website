# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
rank_list = [
  [ 1, 0, "Dirt" ],
  [ 2, 10, "Wood" ],
  [ 3, 30, "Iron" ],
  [ 4, 60, "Bronze" ],
  [ 5, 100, "Silver" ],
  [ 6, 150, "Gold" ],
  [ 7, 210, "Platinum" ],
  [ 8, 280, "Ruby" ],
  [ 9, 360, "Emerald" ],
  [ 10, 450, "Diamond" ],
]

rank_list.each do |level, exp_required, name|
  Rank.create( level: level, exp_required: exp_required, name: name )
end
