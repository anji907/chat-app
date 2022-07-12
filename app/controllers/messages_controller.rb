class MessagesController < ApplicationController
  def index
    @room = Room.find(params[:room_id])
    @message = @room.messages.new
    @messages = @room.messages.includes(:user)
  end

  def create
    @message = Message.new(message_params)
    @room = Room.find(@message.room_id)

    if @message.save
      redirect_to room_messages_path(@message.room_id)
    else
      @messages = @room.messages.includes(:user)
      render :index
    end
  end

  private

  def message_params
    params.require(:message).permit(:content).merge(user_id: current_user.id, room_id: params[:room_id])
  end
end