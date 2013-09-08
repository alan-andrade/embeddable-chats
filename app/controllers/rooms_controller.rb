class RoomsController < ApplicationController
  before_filter :requires_authentication

  def new
    @room = chat.rooms.build
  end

  def create
    @room = chat.rooms.create params_for_create
    if @room.persisted?
      redirect_to dashboard_path
    else
      render :new
    end
  end

  def edit
    @room = Room.find params[:id]
  end

  def update
    @room = chat.rooms.find params[:id]
    if @room && @room.update_attributes(params_for_update)
      redirect_to dashboard_path
    else
      render :edit
    end
  end

  private

  def params_for_create
    params.
      require(:room).
      permit(:subject)
  end

  alias_method :params_for_update, :params_for_create

  def chat
    current_user.chat
  end
end
