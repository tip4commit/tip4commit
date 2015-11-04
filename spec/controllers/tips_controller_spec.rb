require 'spec_helper'

describe TipsController, type: :controller do
  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      expect(response).to be_success
    end
  end

  describe "routing" do
    it "routes GET / to Tips#index" do
      { :get => "/tips" }.should route_to(
        :controller => "tips"  ,
        :action     => "index" )
    end
  end
end
