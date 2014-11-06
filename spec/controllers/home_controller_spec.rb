require 'spec_helper'

describe HomeController do
  describe "index" do
    it "GET index aka /root" do
      get :index
      expect(response).to be_success
      response.status.should be(200)
    end
  end
end
