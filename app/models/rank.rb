class Rank < ActiveRecord::Base
  validates :name, uniqueness: { case_sensitive: false }
  validates :level, uniqueness: true
  validates :exp_required, uniqueness: true
end
