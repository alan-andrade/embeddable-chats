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

  def show
    @room = Room.includes(:users).find params[:id]
    @room.join current_user unless @room.include? current_user
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

  def requires_authentication
    session[:room_id] = params[:id].to_i if params[:action] == 'show'
    super # Call the main ApplucationController requires_authentication
  end

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

# iframe with /rooms/2
#
# no session detected         # store room id
#   ask to authenticate       # create/log user in
#   once authenticated, join  # verify participation
