class ContactsController < ApplicationController

  before_action :load_user, only: %w(show create_message)

  def index
    @contacts = User.active.where(:id.ne => current_user.id).all
  end

  def show
    load_user_messages
    MarkReadUserMessages.new(@user, current_user).perform
    @message = Message.new
  end

  def create_message
    @message = Message.new(message_params.merge(sender_id: current_user.id, receiver_id: @user.id))
    if @message.save
      redirect_to contact_path(@user)
    else
      load_user_messages
      render :show
    end
  end

  def amount_unread_message
    render json: { unread_message_count: current_user.unread_message_count }
  end

  private

  def load_user
    @user ||= User.find(params[:id])
  end

  def load_user_messages
    @messages ||= Message.by_users(current_user.id, @user.id).all
  end

  def message_params
    params.require(:message).permit(:message)
  end

end
