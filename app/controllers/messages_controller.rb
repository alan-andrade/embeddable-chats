class MessagesController < ApplicationController
  before_filter :requires_authentication

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

