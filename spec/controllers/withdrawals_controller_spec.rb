require 'spec_helper'

describe WithdrawalsController, type: :controller do
  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      expect(response).to be_successful
    end
  end

  describe "routing" do
    it "routes GET / to Withdrawals#index" do
      expect({ :get => "/withdrawals" }).to route_to(
        :controller => "withdrawals",
        :action     => "index")
    end
  end
end
