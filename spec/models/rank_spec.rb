require 'spec_helper'

describe Rank do
  describe "validations" do
    it "should not create the following violations." do
      rank = create(:rank)
      build(:rank, :name => rank.name).should_not be_valid
      build(:rank, :level => rank.level).should_not be_valid
      build(:rank, :exp_required => rank.exp_required).should_not be_valid
    end
  end

  describe "methods" do
    it "level_to_exp should return 'level-exp_required' in a string" do
        rank = build(:rank)
        rank.level_to_exp.should eq(rank.level.to_s + "-" + rank.exp_required.to_s)
    end
  end
end
