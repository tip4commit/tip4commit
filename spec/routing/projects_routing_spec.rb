# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'routes for Projects', type: :routing do
  it 'routes GET /projects to Project#index' do
    expect({ get: '/projects' }).to route_to(
      controller: 'projects',
      action: 'index'
    )
  end

  it 'routes GET /projects/search?query= to Project#search' do
    expect({ get: '/projects/search?query=seldon&order=balance' }).to route_to(
      controller: 'projects',
      action: 'search',
      query: 'seldon',
      order: 'balance'
    )
  end

  it 'routes GET /projects/1 to Project#show' do
    expect({ get: '/projects/1' }).to route_to(
      controller: 'projects',
      action: 'show',
      id: '1'
    )
  end

  it 'routes GET /projects/1/edit to Project#edit' do
    expect({ get: '/projects/1/edit' }).to route_to(
      controller: 'projects',
      action: 'edit',
      id: '1'
    )
  end

  it 'routes PUT /projects/1 to Project#update' do
    expect({ put: '/projects/1' }).to route_to(
      controller: 'projects',
      action: 'update',
      id: '1'
    )
  end

  it 'routes GET /projects/1/decide_tip_amounts to Project#decide_tip_amounts' do
    expect({ get: '/projects/1/decide_tip_amounts' }).to route_to(
      controller: 'projects',
      action: 'decide_tip_amounts',
      id: '1'
    )
  end

  it 'routes PATCH /projects/1/decide_tip_amounts to Project#decide_tip_amounts' do
    expect({ patch: '/projects/1/decide_tip_amounts' }).to route_to(
      controller: 'projects',
      action: 'decide_tip_amounts',
      id: '1'
    )
  end

  it 'routes GET /projects/1/tips to Tips#index' do
    expect({ get: '/projects/1/tips' }).to route_to(
      controller: 'tips',
      action: 'index',
      project_id: '1'
    )
  end

  it 'routes GET /projects/1/deposits to Deposits#index' do
    expect({ get: '/projects/1/deposits' }).to route_to(
      controller: 'deposits',
      action: 'index',
      project_id: '1'
    )
  end

  describe 'Project pretty url routing' do
    it 'routes GET /:provider/:repo to Project#show' do
      expect({ get: '/github/test/test' }).to route_to(
        controller: 'projects',
        action: 'show',
        service: 'github',
        repo: 'test/test'
      )
    end

    it 'routes GET /:provider/:repo/edit to Project#edit' do
      expect({ get: '/github/test/test/edit' }).to route_to(
        controller: 'projects',
        action: 'edit',
        service: 'github',
        repo: 'test/test'
      )
    end

    it 'routes GET /:provider/:repo/decide_tip_amounts to Project#decide_tip_amounts' do
      expect({ get: '/github/test/test/decide_tip_amounts' }).to route_to(
        controller: 'projects',
        action: 'decide_tip_amounts',
        service: 'github',
        repo: 'test/test'
      )
    end

    it 'routes GET /:provider/:repo/tips to Project#tips' do
      expect({ get: '/github/test/test/tips' }).to route_to(
        controller: 'tips',
        action: 'index',
        service: 'github',
        repo: 'test/test'
      )
    end

    it 'routes GET /:provider/:repo/deposits to Project#deposits' do
      expect({ get: '/github/test/test/deposits' }).to route_to(
        controller: 'deposits',
        action: 'index',
        service: 'github',
        repo: 'test/test'
      )
    end
  end
end
