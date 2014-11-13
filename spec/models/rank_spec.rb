require 'spec_helper'

describe Rank do
  describe "validations" do
    pending "test uniqueness for name, level, and exp_required in #{__FILE__}"
  end

  describe "methods" do
    it "level_to_exp should return 'level-exp_required' in a string" do
        rank = build(:rank)
        rank.level_to_exp.should eq(rank.level.to_s + "-" + rank.exp_required.to_s)
    end
  end
end
