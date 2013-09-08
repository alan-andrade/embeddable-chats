require 'spec_helper'

describe ApplicationController do
  describe 'requires_authentication filter' do

    controller do
      before_filter :requires_authentication
      def index() render nothing: true end
    end

    it 'redirects to root_path if no authenticated user' do
      get :index
      expect(response).to redirect_to(root_path)
    end
  end

end

