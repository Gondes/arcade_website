class Faq < ActiveRecord::Base
  validates :question, presence: { :message => "can't be empty" }
end
