require 'spec_helper'

describe ProjectsController do
  describe '#index' do
    let(:subject) { get :index }
    before do
      allow(Project).to receive(:order).with(available_amount_cache: :desc, watchers_count: :desc, full_name: :asc).and_return(Project)
      allow(Project).to receive(:page).with(nil).and_return(Project)
      allow(Project).to receive(:per).with(30).and_return(Project)
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
end
