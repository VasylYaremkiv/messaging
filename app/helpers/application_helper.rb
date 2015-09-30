module ApplicationHelper

  def message_from_me?(message, user)
    message.sender_id == user.id
  end

  def message_sender(message, user)
    message_from_me?(message, user) ? 'me' : 'you'
  end

end
