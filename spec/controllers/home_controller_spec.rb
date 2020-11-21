require 'spec_helper'

describe HomeController, type: :controller do
  describe 'GET #index' do
    let(:subject) { get :index }

    it 'renders index template' do
      expect(subject).to render_template :index
    end

    it 'returns 200 status code' do
      expect(subject.status).to eq 200
    end
  end

  describe "routing" do
    it "routes GET / to Home#index" do
      expect({ :get => "/" }).to route_to(
        :controller => "home",
        :action     => "index")
    end

    it "routes GET /home to Home#index" do
      expect({ :get => "/" }).to route_to(
        :controller => "home",
        :action     => "index")
    end

    it "routes GET /users/999999/no-such-path to Home#index" do
      expect({ :get => "/users/999999/no-such-path" }).to route_to(
        :controller => "home",
        :action     => "index",
        :path       => "users/999999/no-such-path")
    end

    it "routes GET /any/non-existent/path to Home#index" do
      expect({ :get => "/any/non-existent/path" }).to route_to(
        :controller => "home",
        :action     => "index",
        :path       => "any/non-existent/path")
    end
  end
end
