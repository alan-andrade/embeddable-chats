class MessagesController < ApplicationController
  before_filter :requires_authentication
  respond_to :json, :html

  def index
    room = Room.find params[:room_id]
    params_created_at = params[:created_at]
    time_limit = params_created_at.nil? ? Time.now : Time.parse(params_created_at)

    @messages = room.messages.where{ created_at.gt my{ time_limit } }

    respond_with @messages do |format|
      format.json do
        render json: @messages.map{|m| { id: m.id, body: m.body, created_at: m.created_at } }.to_json
      end
    end
  end

  def create
    @room = Room.find params[:room_id]
    @message = @room.messages.create params_for_create.merge sender: current_user

    respond_with @room # this is weeeeird
  end

  private

  def params_for_create
    params.require(:message).permit(:body)
  end

  def params_for_index
    params.permit(:created_at)
  end
end

