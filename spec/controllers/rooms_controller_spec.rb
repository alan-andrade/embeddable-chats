require 'spec_helper'

describe RoomsController do
  let(:user) { stub_model(User, chat: stub_model(Chat)) }

  before { controller.stub current_user: user }

  describe 'GET#new' do
    it 'renders a form to create a new room' do
      get :new
      expect(response).to render_template 'rooms/new'
    end

    it 'should have an existing chat in context' do
      expect(@controller.send(:chat)).to be_a Chat
    end
  end

  describe 'POST#create' do
    it 'redirects to dashboard_path once created' do
      post :create, room: { subject: 'dogs' }
      expect(response).to redirect_to(dashboard_path)
      expect(Room.count).to eq 1
      expect(Room.last.subject).to eq 'dogs'
    end

    it 'renders the room form if any error' do
      Room.any_instance.stub persisted?: false
      post :create, room: { subject: 'cats' }
      expect(response).to render_template 'rooms/new'
    end
  end

  describe 'GET#edit' do
    it 'should render a form to edit the room' do
      Room.stub find: stub_model(Room, subject: 'Cats')
      get :edit, id: 1
      expect(response).to render_template 'rooms/edit'
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
      expect(response).to redirect_to dashboard_path
    end

    it 'should render edit in case of any error' do
      room.stub update_attributes: false
      put :update, id: 3, room: { foo: 123 }
      expect(response).to render_template 'rooms/edit'
    end
  end

  describe 'GET#show' do
    context 'with brand new visitor' do
      before { controller.stub current_user: nil }

      it 'should store the room id for later use' do
        get :show, id: 1
        expect(session[:room_id]).to equal 1
      end
    end

    context 'with welcoming back user' do
      it 'should join the user into the room' do
        room = stub_model Room
        room.should_receive(:join).with(user)

        Room.stub_chain(:includes, :find).and_return room
        get :show, id: 1
      end
    end
  end

end
