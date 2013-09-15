class MessagesController < ApplicationController
  before_filter :requires_authentication
  respond_to :json, :html

  def index
    room = Room.find params[:room_id]
    @messages = room.messages
    respond_with @messages do |format|
      format.json do
        render json: @messages.map{|m| { id: m.id, body: m.body } }.to_json
      end
    end
  end

  def create
    @room = Room.find params[:room_id]
    @message = @room.messages.create params_for_create
    if @message.persisted?
      redirect_to @room
    end
  end

  def params_for_create
    params.require(:message).permit(:body)
  end
end

