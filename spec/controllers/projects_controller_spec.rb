require 'spec_helper'

describe ProjectsController do
  describe '#index' do
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

  describe '#search' do
    let(:subject) { get :search, query: "https://github.com/mitsuhiko/flask" }

    it 'renders blacklisted template' do
      expect(subject).to render_template :blacklisted
    end
  end

  describe '#show' do
    context 'with existing project that has been blacklisted' do
      let(:blacklisted_project) { create(:project, host: "github", full_name: "mitsuhiko/flask") }
      let(:subject) { get :show, service: "github", repo: blacklisted_project.full_name }

      it 'renders blacklisted template' do
        expect(subject).to render_template :blacklisted
      end
    end
  end
end
