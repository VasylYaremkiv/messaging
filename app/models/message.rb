class Message
  include Mongoid::Document
  include Mongoid::Timestamps

  field :message, type: String
  field :read, type: Boolean, default: false

  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'

  scope :by_users, -> (sender, receiver) do
    any_of({ sender_id: sender, receiver_id: receiver },
           { receiver_id: sender, sender_id: receiver })
  end

  scope :by_sender, -> (sender) { where(sender_id: sender) }
  scope :by_receiver, -> (receiver) { where(receiver_id: receiver) }
  scope :unread, -> { where(read: false) }
  scope :unread_by_users, ->(sender, receiver) { by_sender(sender).by_receiver(receiver).unread }

  validates :message, presence: true

  after_create :increment_receiver_unread_message

  private

  def increment_receiver_unread_message
    receiver.inc(unread_message_count: 1)
  end

end
