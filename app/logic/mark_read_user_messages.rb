class MarkReadUserMessages
  attr_reader :sender, :receiver

  def initialize(sender, receiver)
    @sender, @receiver = sender, receiver
  end

  def perform
    messages = Message.unread_by_users(sender.id, receiver.id)
    receiver.inc(unread_message_count: -messages.count)
    messages.update_all(read: true)
  end

end