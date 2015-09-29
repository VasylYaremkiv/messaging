class MessagesController < ApplicationController

  def index
    @contacts = User.active.where(:id.ne => current_user.id).all
  end

end
