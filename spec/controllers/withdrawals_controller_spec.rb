require 'spec_helper'

describe WithdrawalsController do
  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      expect(response).to be_success
    end
  end

  describe "routing" do
    it "routes GET / to Withdrawals#index" do
      { :get => "/withdrawals" }.should route_to(
        :controller => "withdrawals" ,
        :action     => "index"       )
    end
  end
end
