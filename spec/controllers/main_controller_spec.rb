require 'rails_helper'

RSpec.describe MainController, type: :controller do
  describe 'GET index' do
    it "renders template" do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe 'GET top_pages.json' do
    it "renders template" do
      get :top_pages, format: :json do
        expect(response).to render_template(:top_pages)
      end
    end
  end

  describe 'GET top_referrers.json' do
    it "renders template" do
      get :top_referrers, format: :json do
        expect(response).to render_template(:top_referrers)
      end
    end
  end
end
