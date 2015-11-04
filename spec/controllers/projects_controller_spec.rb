require 'spec_helper'

describe ProjectsController, type: :controller do
  describe 'GET #index' do
    let(:subject) { get :index }
    before do
      allow(Project).to receive(:order).with(available_amount_cache: :desc, watchers_count: :desc, full_name: :asc).and_return(Project)
      allow(Project).to receive(:page).with(nil).and_return(Project)
      allow(Project).to receive(:per).with(30).and_return(Project)
      allow(Project).to receive(:to_a).and_return(Project)
      allow(Project).to receive(:reject!).and_return(Project)
    end

    it 'renders index template' do
      expect(subject).to render_template :index
    end

    it 'returns 200 status code' do
      expect(subject.status).to eq 200
    end

    it 'Project calls order' do
      expect(Project).to receive(:order).with(available_amount_cache: :desc, watchers_count: :desc, full_name: :asc).and_return(Project)
      subject
    end

    it 'Project calls page' do
      expect(Project).to receive(:page).with(nil).and_return(Project)
      subject
    end

    it 'Project calls per' do
      expect(Project).to receive(:per).with(30).and_return(Project)
      subject
    end

    it 'assigns @projects' do
      subject
      expect(assigns[:projects].name).to eq 'Project'
    end
  end

  describe 'GET #search' do
    context 'with existing repo that has been blacklisted' do
      let(:subject) { get :search, query: "https://github.com/mitsuhiko/flask" }

      it 'renders blacklisted template' do
        expect(subject).to render_template :blacklisted
      end
    end
  end

  describe 'POST #search' do
    it 'returns 200 status code' do
      post :search
      response.should be_success
    end
  end

=begin TODO: NFG - No route matches {:controller=>"projects", :action=>"update"}
  describe 'PUT #update' do
    it 'returns 200 status code' do
      put :update
      response.should be_success
    end
  end
=end

  shared_context 'accessing_project' do |verb , action|
    let(:a_project) { create :project , :host => 'github' , :full_name => "test/test" }

    context 'existing_project' do
      it 'via project id returns 302 status code' do
        case verb
        when :get ;   get   action , :id => a_project.id
        when :patch ; patch action , :id => a_project.id
        end
        response.should be_redirect
      end

      it 'via project name returns 200 status code' do
        case verb
        when :get ;   get   action , :service => 'github' , :repo => a_project.full_name
        when :patch ; patch action , :service => 'github' , :repo => a_project.full_name
        end
        response.should be_success
      end
    end

    context 'nonexisting_project' do
      it 'via project id returns 302 status code' do
        case verb
        when :get ;   get   action , :id => 999999
        when :patch ; patch action , :id => 999999
        end
        response.should be_redirect
      end

      it 'via project name returns 200 status code' do
        case verb
        when :get ;   get   action , :service => 'github' , :repo => 'no-such/project' ;
        when :patch ; patch action , :service => 'github' , :repo => 'no-such/project' ;
        end
        response.should be_redirect
      end
    end
  end

  describe 'GET #show' do
    include_context 'accessing_project' , :get , :show

    context 'with existing repo that has been blacklisted' do
      let(:blacklisted_repo) { create(:project, host: "github", full_name: "mitsuhiko/flask") }
      let(:subject) { get :show, service: "github", repo: blacklisted_repo.full_name }

      it 'renders blacklisted template' do
        expect(subject).to render_template :blacklisted
      end
    end
  end

  describe 'GET #edit' do
    it 'returns 302 status code' do
# TODO: requires logged in user who is project collaborator
#     include_context 'accessing_project' , :get , :edit

      get :edit , :service => 'github' , :repo => 'test/test'
      response.should be_redirect
    end
  end

  describe 'GET #decide_tip_amounts' do
# TODO: requires logged in user who is project collaborator and some tips
#     include_context 'accessing_project' , :get , :decide_tip_amounts

    it 'returns 302 status code' do
      get :decide_tip_amounts , :service => 'github' , :repo => 'test/test'
      response.should be_redirect
    end
  end

  describe 'PATCH #decide_tip_amounts' do
# TODO: requires logged in user who is project collaborator and some tips
#     include_context 'accessing_project' , :patch , :decide_tip_amounts

    it 'returns 302 status code' do
      patch :decide_tip_amounts , :service => 'github' , :repo => 'test/test'
      response.should be_redirect
    end
  end

  describe "routing" do
    it "routes GET /projects to Project#index" do
      { :get => "/projects" }.should route_to(
        :controller => "projects" ,
        :action     => "index"    )
    end

    it "routes GET /projects/search?query= to Project#search" do
      { :get => "/projects/search?query=seldon&order=balance" }.should route_to(
        :controller => "projects" ,
        :action     => "search"   ,
        :query      => "seldon"     ,
        :order      => "balance"  )
    end

    it "routes GET /projects/1 to Project#show" do
      { :get => "/projects/1" }.should route_to(
        :controller => "projects" ,
        :action     => "show"   ,
        :id         => "1"        )
    end

    it "routes GET /projects/1/edit to Project#edit" do
      { :get => "/projects/1/edit" }.should route_to(
        :controller => "projects" ,
        :action     => "edit"   ,
        :id         => "1"        )
    end

    it "routes PUT /projects/1 to Project#update" do
      { :put => "/projects/1" }.should route_to(
        :controller => "projects" ,
        :action     => "update"   ,
        :id         => "1"        )
    end

    it "routes GET /projects/1/decide_tip_amounts to Project#decide_tip_amounts" do
      { :get => "/projects/1/decide_tip_amounts" }.should route_to(
        :controller => "projects" ,
        :action     => "decide_tip_amounts"   ,
        :id         => "1"        )
    end

    it "routes PATCH /projects/1/decide_tip_amounts to Project#decide_tip_amounts" do
      { :patch => "/projects/1/decide_tip_amounts" }.should route_to(
        :controller => "projects"           ,
        :action     => "decide_tip_amounts" ,
        :id         => "1"                  )
    end

    it "routes GET /projects/1/tips to Tips#index" do
      { :get => "/projects/1/tips" }.should route_to(
        :controller => "tips"     ,
        :action     => "index"    ,
        :project_id => "1"        )
    end

    it "routes GET /projects/1/deposits to Deposits#index" do
      { :get => "/projects/1/deposits" }.should route_to(
        :controller => "deposits" ,
        :action     => "index"    ,
        :project_id => "1"        )
    end
  end

  describe "Project pretty url routing" do
    it "routes GET /:provider/:repo to Project#show" do
      { :get => "/github/test/test" }.should route_to(
        :controller => "projects" ,
        :action     => "show"     ,
        :service    => "github"   ,
        :repo       => "test/test")
    end

    it "routes GET /:provider/:repo/edit to Project#edit" do
      { :get => "/github/test/test/edit" }.should route_to(
        :controller => "projects" ,
        :action     => "edit"     ,
        :service    => "github"   ,
        :repo       => "test/test")
    end

    it "routes GET /:provider/:repo/decide_tip_amounts to Project#decide_tip_amounts" do
      { :get => "/github/test/test/decide_tip_amounts" }.should route_to(
        :controller => "projects"               ,
        :action     => "decide_tip_amounts"     ,
        :service    => "github"                 ,
        :repo       => "test/test"              )
    end

    it "routes GET /:provider/:repo/tips to Project#tips" do
      { :get => "/github/test/test/tips" }.should route_to(
        :controller => "tips" ,
        :action     => "index" ,
        :service    => "github"   ,
        :repo       => "test/test")
    end

    it "routes GET /:provider/:repo/deposits to Project#deposits" do
      { :get => "/github/test/test/deposits" }.should route_to(
        :controller => "deposits" ,
        :action     => "index" ,
        :service    => "github"   ,
        :repo       => "test/test")
    end
  end
end
