require 'spec_helper'

describe RoomsController do
  before do
    controller.stub current_user: stub_model(User, chat: stub_model(Chat))
  end

  describe 'GET#new' do
    it 'renders a form to create a new room' do
      get :new
      response.should render_template 'rooms/new'
    end

    it 'should have an existing chat in context' do
      @controller.send(:chat).should be_a Chat
    end
  end

  describe 'POST#create' do
    it 'redirects to dashboard_path once created' do
      post :create, room: { subject: 'dogs' }
      response.should redirect_to dashboard_path
      Room.count.should == 1
      Room.last.subject.should == 'dogs'
    end

    it 'renders the room form if any error' do
      Room.any_instance.stub persisted?: false
      post :create, room: { subject: 'cats' }
      response.should render_template 'rooms/new'
    end
  end

  describe 'GET#edit' do
    it 'should render a form to edit the room' do
      Room.stub find: stub_model(Room, subject: 'Cats')
      get :edit, id: 1
      response.should render_template 'rooms/edit'
    end
  end

  describe 'PUT#update' do
    let(:room) { stub_model(Room, subject: 'Cats') }

    before do
      chat = stub_model(Chat)
      chat.rooms.stub find: room
      controller.stub chat: chat
    end

    it 'should update the room attributes' do
      put :update, id: 1, room: { subject: 'Horses' }
      response.should redirect_to dashboard_path
    end

    it 'should render edit in case of any error' do
      room.stub update_attributes: false
      put :update, id: 3, room: { foo: 123 }
      response.should render_template 'rooms/edit'
    end
  end
end
