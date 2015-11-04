require 'spec_helper'

describe DepositsController, type: :controller do
  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      expect(response).to be_success
    end
  end

  describe "routing" do
    it "routes GET / to Deposits#index" do
      { :get => "/deposits" }.should route_to(
        :controller => "deposits" ,
        :action     => "index"    )
    end
  end
end
