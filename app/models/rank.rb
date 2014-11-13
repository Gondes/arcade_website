class Rank < ActiveRecord::Base
  validates :name, uniqueness: { case_sensitive: false }
  validates :level, uniqueness: true
  validates :exp_required, uniqueness: true

  def level_to_exp
    self.level.to_s + "-" + self.exp_required.to_s
  end
end
